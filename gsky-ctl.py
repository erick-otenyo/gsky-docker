#!/usr/bin/env python3

import argparse
import os
import subprocess
import yaml
from dotenv import dotenv_values

DOCKER_COMPOSE_ARGS = """
    --file docker-compose.yml
    --env-file .env
    """

parser = argparse.ArgumentParser(
    description='manage a composition of docker containers to implement gsky server',
    formatter_class=argparse.RawTextHelpFormatter)

parser.add_argument(
    '--simulate',
    dest='simulate',
    action='store_true',
    help='simulate execution by printing action rather than executing')

commands = [
    'setup',
    'build',
    'config',
    'down',
    'logs',
    'login',
    'prune',
    'restart',
    'start',
    'start-dev',
    'status',
    'stop',
    'up',
    'update',
]

parser.add_argument('command',
                    choices=commands,
                    help="""
    - config: validate and view Docker configuration
    - build [containers]: build all services
    - start [containers]: start system
    - start-dev [containers]: start system in local development mode
    - login [container]: login to the container (default: wis2box)
    - stop: stop [container] system
    - update: update Docker images
    - prune: cleanup dangling containers and images
    - restart [containers]: restart one or all containers
    - status [containers|-a]: view status of gsky containers
    """)

parser.add_argument('args', nargs=argparse.REMAINDER)

args = parser.parse_args()


def split(value: str) -> list:
    """
    Splits string and returns as list

    :param value: required, string. bash command.

    :returns: list. List of separated arguments.
    """
    return value.split()


def walk_path(path: str) -> list:
    """
    Walks os directory path collecting all CSV files.

    :param path: required, string. os directory.

    :returns: list. List of csv filepaths.
    """
    file_list = []
    for root, _, files in os.walk(path, topdown=False):
        for name in files:
            if name.endswith('.py'):
                file_list.append(os.path.join(root, name))

    return file_list


def run(args, cmd, asciiPipe=False) -> str:
    if args.simulate:
        if asciiPipe:
            print(f"simulation: {' '.join(cmd)} >/tmp/temp_buffer$$.txt")
        else:
            print(f"simulation: {' '.join(cmd)}")
        return '`cat /tmp/temp_buffer$$.txt`'
    else:
        if asciiPipe:
            return subprocess.run(
                cmd, stdout=subprocess.PIPE).stdout.decode('ascii')
        else:
            subprocess.run(cmd)
    return None


def setup_docker_compose() -> bool:
    WORKERNODES_NUMBER = 1

    env = dotenv_values(".env")

    if env.get("WORKERNODES_NUMBER"):
        WORKERNODES_NUMBER = int(env.get("WORKERNODES_NUMBER"))

    config = None

    #  read docker-compose.base.yml
    with open("docker-compose.base.yml", "r") as f:
        config = yaml.load(f, Loader=yaml.FullLoader)
        new_config = {**config}
        worker_default_config = {config.get("services", {}).get("gsky_rpc_1")}

        if worker_default_config and WORKERNODES_NUMBER > 1:
            for i in range(WORKERNODES_NUMBER):
                new_config["services"][f"gsky_rpc_{i + 1}"] = {**worker_default_config}

    # write config to docker-compose.yml
    with open("docker-compose.yml", "w") as f:
        print(new_config)
        yaml.dump(new_config, f)


def make(args) -> None:
    """
    Serves as pseudo Makefile using Python subprocesses.

    :param command: required, string. Make command.

    :returns: None.
    """

    # if you selected a bunch of them, default to all
    containers = "" if not args.args else ' '.join(args.args)

    # if there can be only one, default to wisbox
    container = "gsky_mas_api" if not args.args else ' '.join(args.args)

    if args.command == "setup":
        setup_docker_compose()

    elif args.command == "config":
        run(args, split(f'docker-compose {DOCKER_COMPOSE_ARGS} config'))
    elif args.command == "build":
        run(args, split(
            f'docker-compose {DOCKER_COMPOSE_ARGS} build {containers}'))
    elif args.command in ["up", "start", "start-dev"]:
        run(args, split(
            'docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions > /dev/null 2>&1'))
        run(args, split(
            'docker plugin enable loki'))
        if containers:
            run(args, split(f"docker-compose {DOCKER_COMPOSE_ARGS} start {containers}"))
        else:
            if args.command == 'start-dev':
                run(args, split(f'docker-compose {DOCKER_COMPOSE_ARGS} --file docker/docker-compose.dev.yml up'))
            else:
                run(args, split(f'docker-compose {DOCKER_COMPOSE_ARGS} up -d'))
    elif args.command == "login":
        run(args, split(f'docker exec -it {container} /bin/bash'))
    elif args.command == "login-root":
        run(args, split(f'docker exec -u -0 -it {container} /bin/bash'))
    elif args.command == "logs":
        run(args, split(
            f'docker-compose {DOCKER_COMPOSE_ARGS} logs --follow {containers}'))
    elif args.command in ["stop", "down"]:
        if containers:
            run(args, split(f"docker-compose {DOCKER_COMPOSE_ARGS} {containers}"))
        else:
            run(args, split(
                f'docker-compose {DOCKER_COMPOSE_ARGS} down --remove-orphans {containers}'))
    elif args.command == "update":
        run(args, split(f'docker-compose {DOCKER_COMPOSE_ARGS} pull'))
    elif args.command == "prune":
        run(args, split('docker builder prune -f'))
        run(args, split('docker container prune -f'))
        run(args, split('docker volume prune -f'))
        _ = run(args,
                split('docker images --filter dangling=true -q --no-trunc'),
                asciiPipe=True)
        run(args, split(f'docker rmi {_}'))
        _ = run(args, split('docker ps -a -q'), asciiPipe=True)
        run(args, split(f'docker rm {_}'))
    elif args.command == "restart":
        if containers:
            run(args, split(
                f'docker-compose {DOCKER_COMPOSE_ARGS} stop {containers}'))
            run(args, split(
                f'docker-compose {DOCKER_COMPOSE_ARGS} start {containers}'))
        else:
            run(args, split(
                f'docker-compose {DOCKER_COMPOSE_ARGS} down --remove-orphans'))
            run(args, split(
                f'docker-compose {DOCKER_COMPOSE_ARGS} up -d'))
    elif args.command == "status":
        run(args, split(
            f'docker-compose {DOCKER_COMPOSE_ARGS} ps {containers}'))


if __name__ == "__main__":
    make(args)

#!python
# vim:fileencoding=utf-8

""" [NAME] script or package easy description

[DESCRIPTION] script or package description
"""
from datetime import datetime
from argparse import ArgumentParser
import pprint
import time
import warnings
import os, sys, io
import signal
import json
import random
import re

__author__  = 'holly'
__version__ = '1.0'

TERMINAL_SETTINGS_JSON = os.path.join(os.environ["USERPROFILE"], "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json")

def terminal_settings_json():

    with open(TERMINAL_SETTINGS_JSON, "r", encoding="utf-8_sig") as f:
        lines = []
        for line in f:
            line = line.rstrip()
            m = re.search(r'^\s*//.*$', line)
            if m:
                continue
            else:
                lines.append(line)

        text = "\n".join(lines)
        data = json.loads(text)

    return data

def get_background_image_prop():

    data = terminal_settings_json()

    props = { "BackgroundImage": "", "BackgroundImageOpacity": "" }
    if "backgroundImage" in data["profiles"]["defaults"]:
        props["BackgroundImage"] = data["profiles"]["defaults"]["backgroundImage"]
    if "backgroundImageOpacity" in data["profiles"]["defaults"]:
        props["BackgroundImageOpacity"] = data["profiles"]["defaults"]["backgroundImageOpacity"]

    return props

def get_wallpapers():

    wallpapers = []
    for f in os.listdir(os.environ["TERMINAL_WALLPAPER_DIR"]):
        fullpath = os.path.join(os.environ["TERMINAL_WALLPAPER_DIR"], f)
        if os.path.isfile(fullpath) and re.search(r"^(.*)\.(jpeg|jpg|png)$", f, re.IGNORECASE):
            wallpapers.append(f)

    return wallpapers

def command_get(args):

    props = get_background_image_prop()
    print(json.dumps(props, indent=4))

def command_set(args):

    props                    = get_background_image_prop()
    background_image         = args.background_image
    background_image_opacity = args.background_image_opacity

    if background_image:
        if re.search(r'\\', background_image):
            if not os.path.isfile(background_image):
                print("{} is not exists".format(background_image))
                sys.exit(1)
            background_image = os.path.abspath(background_image)
        else:
            background_image = os.path.join(os.environ["TERMINAL_WALLPAPER_DIR"], background_image)
            if not os.path.isfile(background_image):
                print("{} is not exists".format(background_image))
                sys.exit(1)

    else:
        # wallpaperフォルダからランダムで取得する
        wallpapers = get_wallpapers()
        while props["BackgroundImage"] == background_image or background_image is None:
            wallpaper = random.choice(wallpapers)
            background_image = os.path.join(os.environ["TERMINAL_WALLPAPER_DIR"], wallpaper)

    data = terminal_settings_json()
    data["profiles"]["defaults"]["backgroundImage"]        = background_image
    data["profiles"]["defaults"]["backgroundImageOpacity"] = background_image_opacity

    json_str = json.dumps(data, indent=4, ensure_ascii=False)

    if args.save_terminal_setting_json:
        #with open(TERMINAL_SETTINGS_JSON, "w", newline="\n") as f:
        with open(TERMINAL_SETTINGS_JSON, "w", newline="\n", encoding="utf-8_sig") as f:
            print(json_str, file=f)
    else:
        print(json_str)

def main():
    """ [FUNCTIONS] method or functon description
    """

    parser = ArgumentParser(description="window terminal background image set tool")
    parser.add_argument('--version', action='version', version='%(prog)s ' + __version__)
    subparser = parser.add_subparsers()

    parser_set = subparser.add_parser("set", help="see set")
    parser_set.add_argument("-i", "--background-image", help="specify backgroundImage")
    parser_set.add_argument("-o", "--background-image-opacity", help="specify backgroundImageOpacity", type=float, default=0.2)
    parser_set.add_argument("--save-terminal-setting-json", help="save windows terminal settings.json", action="store_true")

    parser_get = subparser.add_parser("get", help="see get")

    parser_set.set_defaults(func=command_set)
    parser_get.set_defaults(func=command_get)

    args = parser.parse_args()
    if not hasattr(args, "func"):
        parser.print_help()
        sys.exit(1)

    args.func(args)


if __name__ == "__main__":
    main()


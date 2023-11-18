# Icon Replacer for macOS Applications

Welcome to the Icon Replacer project!

This tool is designed to personalize your macOS experience by replacing the default icons of applications in the `/Applications` directory with custom icons of your choice.

I am just putting a fancy bash ui on top of a great tool called [fileicon](https://github.com/mklement0/fileicon) which does all the job really.

## Prerequisites

Before you begin, ensure you have the following installed on your macOS:
- `bash` shell (default on macOS)
- `fileicon` command line tool, which can be installed via [Homebrew](https://brew.sh/):
  ```sh
  brew install fileicon
  ```

## Installation

To install the Icon Replacer, simply clone this repository to your local machine:
```sh
git clone https://github.com/patillacode/icon-replacer.git
cd icon-replacer
```

## Usage

To use the script, navigate to the project directory and run:
```sh
./replace_icons.sh
```

## Options

The script supports several options to customize its behavior:

- `-h, --help`: Show the help message and exit.
- `-v, --version`: Show the version and exit.
- `-i, --icons-folder <path>`: Specify a custom path to the icons folder.
- `-f, --force-reset`: Force dock and finder to restart after replacing the icons.
- `-s, --slow`: Run in slow mode, asking for user input after each icon is replaced.
- `-q, --quiet`: Reduce the output to a minimum.

## Troubleshooting

If you encounter any issues, please check the `error_log.txt` file in the project directory for detailed error messages.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'Add some amazing-feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## License

This project is licensed under the MIT License - see the `LICENSE` file for details.

## Acknowledgments

- [fileicon](https://github.com/mklement0/fileicon)


## FAQ

**Q: Will this work on versions of macOS before 10.12?**

A: The script relies on the `fileicon` tool, which is only supported on macOS 10.12 and later.

**Q: Can I revert to the original icons?**

A: Yes, you can use the `fileicon rm` command to remove custom icons and revert to the original ones.

**Q: Where can I find custom icons?**

A: Custom icons can be found on various websites such as [macOSicons](https://macosicons.com/).

**Q: What should I do if the script doesn't change an icon?**

A: Ensure that the icon file name matches the application name exactly and check the `error_log.txt` for any error messages. I have found that some applications require from `sudo`

Enjoy customizing your macOS experience!

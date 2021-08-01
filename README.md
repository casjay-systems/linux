# This is being phased out as I switch to my dotfiles script
# [Jason's DotFiles](https://github.com/casjay)

These are the base dotfiles that I start with when I set up a
new environment. For more specific local needs I use the `.local`
files described in the [`Local Settings`](#local-settings) section.

## Table of Contents

- [Jason's DotFiles](#jasons-dotfiles)
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
  - [Customize](#customize)
    - [Local Settings](#local-settings)
      - [`~/.config/local/bash.local`](#bash.local)
      - [`~/.config/local/gitconfig.local`](#gitconfig.local)
      - [`~/.config/local/vimrc.local`](#vimrc.local)
    - [Forks](#forks)
  - [Update](#update)
  - [Screenshots](#screenshots)
    - [Git](#git)
    - [tmux & vim](#tmux--vim)
  - [License](#license)

## Setup

To set up the `dotfiles` just run the appropriate snippet in the
terminal:  

(:red_circle: **Tested on Debian, Ubuntu, Fedora, Kali, ParrotOS, ArcoLinux, and MacOS)**  
  
(:warning: **DO NOT** run the `setup` snippet if you do not fully
understand [what it does][setup]. Seriously, **DON'T**!). 
  
| OS | Snippet |
|:---|:---|
| `Auto` | `bash -c "$(curl -LsS https://github.com/casjay-systems/linux/raw/main/install.sh)"`|
| `Linux Installer` | `bash -c "$(curl -LsS https://github.com/casjay-systems/linux/raw/main/install.sh)"` |
| `MacOS Installer` | `bash -c "$(curl -LsS https://github.com/casjay-systems/macos/raw/main/install.sh)"` |
| `Windows Installer` | `bash -c "$(curl -LsS https://github.com/casjay-systems/windows/raw/main/install.sh)"` |

That's it! :sparkles:

The setup process will:

* Download the dotfiles on your computer (by default it will
  suggest `~/.local/dotfiles`)
* Create some additional [directories][directories]
* [Symlink][symlink] the
  [`git`](tree/master/src/git),
  [`shell`](tree/master/src/shell), and
  [`vim`](tree/master/src/vim) files
* Install applications / command-line tools for
  [`macOS`](tree/master/src/os/macos) /
  [`linux`](tree/master/src/os/linux)
* Install [`vim` plugins](tree/master/src/vim/vim/plugins)

Setup process in action:

<table>
    <tbody>
        <tr>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/19314446/cd89a592-90a2-11e6-948d-9d75247088ba.gif" alt="Setup process on linux" width="100%">
            </td>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/19048636/e23e347a-89af-11e6-853c-98616b75b6ae.gif" alt="Setup process on linux" width="100%">
            </td>
        </tr>
        <tr align="center">
            <td>macOS</td>
            <td>linux</td>
        </td>
    </tbody>
</table>

## Customize

### Local Settings

The `dotfiles` can be easily extended to suit additional local
requirements by using the following files:

#### `~/.config/local/bash.local`

The `~/.config/local/bash.local` file it will be automatically sourced after
all the other [`bash` related files][shell], thus, allowing
its content to add to or overwrite the existing aliases, settings,
PATH, etc.

Here is a very simple example of a `~/.config/local/bash.local` file:

```bash
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set local aliases.

alias starwars="telnet towel.blinkenlights.nl"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH="$PATH:$HOME/.local/dotfiles/src/bin"

export PATH

```

#### `~/.config/local/gitconfig.local`

The `~/.config/local/gitconfig.local` file it will be automatically included
after the configurations from `~/.gitconfig`, thus, allowing its
content to overwrite or add to the existing `git` configurations.

__Note:__ Use `~/.config/local/gitconfig.local` to store sensitive information
such as the `git` user credentials, e.g.:

```bash
[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgsign = true


[user]

    name = Your Name
    email = yourname@example.com
    signingkey = XXXXXXXX
```

#### `~/.config/local/vimrc.local`

The `~/.config/local/vimrc.local` file it will be automatically sourced after
`~/.vimrc`, thus, allowing its content to add or overwrite the
settings from `~/.vimrc`.

### Forks

If you decide to fork this project, do not forget to substitute
my username with your own in the [`setup` snippets](#setup) and
[in the `setup` script][setup line]

## Update

To update the dotfiles you can either run the [`setup` script][setup]
or, if you want to just update one particular part, run the appropriate
[`os` script](src/os).

## Screenshots

### Git

Output for `git status`:

<table>
    <tbody>
        <tr>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/10561038/f9f11a28-7525-11e5-8e1d-a304ad3557f9.png" alt="Output for Git status on macOS" width="100%">
            </td>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/8397636/3708d218-1ddb-11e5-9d40-21c6871271b9.png" alt="Output for Git status on linux" width="100%">
            </td>
        </tr>
        <tr align="center">
            <td>macOS</td>
            <td>linux</td>
        </td>
    </tbody>
</table>

Output for `git log`:

<table>
    <tbody>
        <tr>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/10560966/e4ec08a6-7523-11e5-8941-4e12f6550a63.png" alt="Output for Git status on macOS" width="100%">
            </td>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/10560955/4b5e1300-7523-11e5-9e96-95ea67de9474.png" alt="Output for Git log on linux" width="100%">
            </td>
        </tr>
        <tr align="center">
            <td>macOS</td>
            <td>linux</td>
        </td>
    </tbody>
</table>

### tmux & vim

<table>
    <tbody>
        <tr>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/10561007/498e1212-7525-11e5-8252-81503b3d6184.png" alt="tmux and vim on macOS" width="100%">
            </td>
            <td>
                <img src="https://cloud.githubusercontent.com/assets/1223565/10560956/557ca2de-7523-11e5-9000-fc1e189a95f5.png" alt="tmux and vim on linux" width="100%">
            </td>
        </tr>
        <tr align="center">
            <td>macOS</td>
            <td>linux</td>
        </td>
    </tbody>
</table>

## License

The code is available under the [MIT license][license].

<!-- Link labels: -->

[directories]: src/os/create_directories.sh
[dotfiles casjay ]: https://github.com/casjay-dotfiles
[github casjay ]: https://github.com/casjay
[license]: LICENSE.txt
[setup line]: src/os/setup.sh
[setup]: src/os/setup.sh
[bash]: src/bash
[shell]: src/shell
[symlink]: src/os/create_symbolic_links.sh
    
    


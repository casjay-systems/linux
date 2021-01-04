#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

declare -a PLUGINS_TO_INSTALL=(
  "aaron-bond.better-comments"
  "ahmadawais.shades-of-purple"
  "Angular.ng-template"
  "bengreenier.vscode-node-readme"
  "bmalehorn.vscode-fish"
  "christian-kohler.npm-intellisense"
  "Cjay.ruby-and-rails-snippets"
  "CoenraadS.bracket-pair-colorizer-2"
  "cyrilletuzi.angular-schematics"
  "d9705996.perl-toolbox"
  "DavidAnson.vscode-markdownlint"
  "davidbabel.vscode-simpler-icons"
  "dbaeumer.vscode-eslint"
  "dnicolson.binary-plist"
  "doggy8088.angular-extension-pack"
  "donjayamanne.githistory"
  "dotiful.dotfiles-syntax-highlighting"
  "DotJoshJohnson.xml"
  "dsznajder.es7-react-js-snippets"
  "duniul.dircolors"
  "dunstontc.viml"
  "eamodio.gitlens"
  "EditorConfig.EditorConfig"
  "eiminsasete.apacheconf-snippets"
  "eliostruyf.vscode-front-matter"
  "esbenp.prettier-vscode"
  "formulahendry.auto-rename-tag"
  "foxundermoon.shell-format"
  "ginfuru.ginfuru-vscode-jekyll-syntax"
  "ginfuru.vscode-jekyll-snippets"
  "glen-84.sass-lint"
  "hangxingliu.vscode-nginx-conf-hint"
  "HexcodeTechnologies.vscode-prettydiff"
  "HookyQR.beautify"
  "infinity1207.angular2-switcher"
  "johnpapa.Angular2"
  "justusadam.language-haskell"
  "keesschollaart.vscode-home-assistant"
  "keyring.Lua"
  "krizzdewizz.refactorix"
  "MariusAlchimavicius.json-to-ts"
  "mechatroner.rainbow-csv"
  "Mikael.Angular-BeastCode"
  "mrmlnc.vscode-apache"
  "ms-azuretools.vscode-docker"
  "ms-python.python"
  "ms-toolsai.jupyter"
  "ms-vscode-remote.remote-containers"
  "ms-vscode-remote.remote-wsl"
  "ms-vscode.powershell"
  "ms-vscode.typescript-javascript-grammar"
  "ms-vscode.vscode-typescript-tslint-plugin"
  "ms-vsliveshare.vsliveshare"
  "nepaul.editorconfiggenerator"
  "nhoizey.gremlins"
  "octref.vetur"
  "oderwat.indent-rainbow"
  "piotrpalarz.vscode-gitignore-generator"
  "PKief.material-icon-theme"
  "quicktype.quicktype"
  "rebornix.ruby"
  "redhat.vscode-yaml"
  "ritwickdey.live-sass"
  "ritwickdey.LiveServer"
  "rohgarg.jekyll-post"
  "rpinski.shebang-snippets"
  "rubbersheep.gi"
  "Shan.code-settings-sync"
  "sidneys1.gitconfig"
  "SimonSiefke.prettier-vscode"
  "sissel.shopify-liquid"
  "steoates.autoimport"
  "streetsidesoftware.code-spell-checker"
  "stringham.move-ts"
  "syler.sass-indented"
  "tanming363.bootstrap-v4"
  "thomascsd.vscode-readme-pattern"
  "timonwong.shellcheck"
  "tomzx.emoji"
  "TzachOvadia.todo-list"
  "VisualStudioExptTeam.vscodeintellicode"
  "vscode-snippet.snippet"
  "WakaTime.vscode-wakatime"
  "wayou.vscode-todo-highlight"
  "wingrunr21.vscode-ruby"
  "Wscats.eno"
  "xabikos.JavaScriptSnippets"
  "yinfei.luahelper"
  "yzhang.markdown-all-in-one"
  "ZainChen.json"
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_code() {
  execute "pkmgr silent-install visual-studio-code" "Install Visual Studio code"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_plugins() {
  setup() {
    local ARRAY="$@"
    local i=""
    for i in "${ARRAY[@]}"; do
      code --install-extension "$i"
    done
  }
  execute "setup $PLUGINS_TO_INSTALL" "Installing plugins"
}

install_settings() {
  mkdir -p "$HOME/.config/Code/User"
  declare FILE_PATH="$HOME/.config/Code/User/settings/settings.json"
  cat <<EOF >"$FILE_PATH"
  {
  "sync.gist": "",
  "bracketPairColorizer.colorMode": "Independent",
  "editor.cursorSmoothCaretAnimation": true,
  "editor.fontFamily": "Hack Nerd Font, Fira Code, Consolas, 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 15,
  "editor.formatOnPaste": true,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": false,
  "editor.quickSuggestionsDelay": 5,
  "editor.renderIndentGuides": true,
  "editor.renderWhitespace": "boundary",
  "editor.suggestSelection": "first",
  "editor.tabCompletion": "on",
  "editor.tabSize": 2,
  "editor.wordWrapColumn": 120,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "git.enableCommitSigning": true,
  "git.enableSmartCommit": true,
  "git.showPushSuccessNotification": true,
  "html.format.endWithNewline": true,
  "liveServer.settings.donotShowInfoMsg": true,
  "markdown.extension.tableFormatter.normalizeIndentation": true,
  "markdown.extension.toc.orderedList": true,
  "php.validate.executablePath": "php",
  "powershell.codeFormatting.autoCorrectAliases": true,
  "search.showLineNumbers": true,
  "shellcheck.exclude": [1017],
  "shellcheck.run": "manual",
  "shellcheck.useWSL": false,
  "terminal.integrated.fontFamily": "Hack Nerd Font",
  "vsintellicode.modify.editor.suggestSelection": "automaticallyOverrodeDefaultValue",
  "workbench.editor.highlightModifiedTabs": true,
  "workbench.startupEditor": "newUntitledFile",
  "workbench.iconTheme": "material-icon-theme",
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "cSpell.enabledLanguageIds": [
    "asciidoc",
    "bat",
    "c",
    "cpp",
    "csharp",
    "css",
    "dockerfile",
    "git-commit",
    "go",
    "handlebars",
    "haskell",
    "home-assistant",
    "html",
    "ini",
    "jade",
    "java",
    "javascript",
    "javascriptreact",
    "jekyll",
    "json",
    "jsonc",
    "latex",
    "less",
    "liquid",
    "lua",
    "makefile",
    "markdown",
    "perl",
    "php",
    "plaintext",
    "powershell",
    "pug",
    "python",
    "restructuredtext",
    "ruby",
    "rust",
    "scala",
    "scss",
    "shellscript",
    "text",
    "typescript",
    "typescriptreact",
    "yaml",
    "yml"
  ],
  "liquid.format": true,
  "liquid.rules": {
    "html": {},
    "js": {},
    "css": {},
    "scss": {},
    "json": {}
  },
  "[markdown]": {
    "files.trimTrailingWhitespace": false,
    "editor.quickSuggestions": true,
    "editor.defaultFormatter": "yzhang.markdown-all-in-one"
  },
  "editor.codeActionsOnSave": {
    "source.fixAll.markdownlint": true,
    "source.fixAll.eslint": true
  },
  "cSpell.language": "en,en-US",
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "vscode.html-language-features"
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "liveSassCompile.settings.formats": [
    {
      "format": "compressed",
      "extensionName": ".css",
      "savePath": "/assets/css"
    }
  ],
  "liveSassCompile.settings.excludeList": ["**/node_modules/**", ".vscode/**"],
  "scss.lint.unknownAtRules": "ignore",
  "scss.lint.unknownProperties": "ignore",
  "liveSassCompile.settings.autoprefix": [],
  "scss.validate": false,
  "liveSassCompile.settings.generateMap": false,
  "markdownlint.config": {
    "MD012": false,
    "MD013": false,
    "MD033": false,
    "MD041": false
  },
  "better-comments.highlightPlainText": true,
  "bracketPairColorizer.forceUniqueOpeningColor": true,
  "bracketPairColorizer.showBracketsInGutter": true,
  "cSpell.customUserDictionaries": [],
  "enableTelemetry": true,
  "terminal.integrated.shell.linux": "/bin/bash",
  "python.languageServer": "Microsoft",
  "files.autoSave": "onWindowChange",
  "terminal.integrated.env.windows": {},
  "cSpell.userWords": [
    "Centralish",
    "Hellotxt",
    "Miley",
    "casjay",
    "gitmasterconfig",
    "prevrepo",
    "printf"
  ],
  "markdown.extension.print.theme": "dark",
  "markdown.extension.toc.omittedFromToc": {},
  "markdown.preview.breaks": true,
  "eslint.alwaysShowStatus": true,
  "eslint.format.enable": true,
  "[xml]": {
    "editor.defaultFormatter": "SimonSiefke.prettier-vscode"
  },
  "[home-assistant]": {
    "editor.insertSpaces": true,
    "editor.tabSize": 2,
    "editor.quickSuggestions": {
      "other": true,
      "comments": false,
      "strings": true
    },
    "editor.autoIndent": "full"
  },
  "cSpell.enabled": false,
  "[shellscript]": {
    "files.eol": "\n"
  },
  "workbench.editor.enablePreview": false,
  "editor.renameOnType": true,
  "[typescript]": {
    "editor.defaultFormatter": "vscode.typescript-language-features"
  },
  "javascript.updateImportsOnFileMove.enabled": "always",
  "python.defaultInterpreterPath": "python3",
  "[vue]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
EOF
  #
  if [ -f "$FILE_PATH" ]; then
    isInFile=$(cat "$FILE_PATH" | grep -c "shellcheck.exclude")
    if [ $isInFile -eq 0 ]; then

      execute \
        "printf '%s' '$CONFIGS' >$FILE_PATH" \
        "settings.json → $FILE_PATH"
    fi
  fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  install_code
  install_plugins
  install_settings

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main

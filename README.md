dotfiles
========
Fork of urdh/dotfiles.  After looking for an easy way to symlink all my organized dotfiles, I found this project.

advanced install
----------------
If you plan on version-controlling your dotfiles as well (and feel comfortable using Git), I recommend forking the repository on Github, then creating your own branch(es) for whatever machines you've got dotfiles on (and closing the branches you won't use):

1. [Fork the repository on Github](https://help.github.com/articles/fork-a-repo).
2. `git clone git@github.com:<username>/dotfiles.git ~/.dotfiles`

You can now start moving your dotfiles into `~/.dotfiles`, splitting them into categories, projects or any other organized mess. Customize the `Rules` file and commit+push your initial setup.
I prefer to make one commit for every logical change, since that makes it easy to cherrypick or disable specific files by reverting or transplanting changesets between branches.

If you choose to fork the project, and make useful changes to the `dotfiles.rb` script (or add useful dotfiles to the `contrib/` directory), feel free to [send a pull request](https://help.github.com/articles/using-pull-requests).

the rules
=========
The script reads instructions from `~/.dotfiles/Rules` and applies these to process the files in `~/.dotfiles`.
Each file matches only one rule, and rules are matched in the order that they appear in the `Rules` file.

There are three different instructions available:

* `ignore <regex>` tells the script to ignore all files and directories matching the regular expression `<regex>`.
* `symlink <regex>, <target>` tells the script to create a symlink from `~/<target>` to the file matching `<regex>`. The target filename may contain tokens of the type `$[1-9]` which will be replaced by the corresponding matching group in the regular expression.
* `merge <regex>, <target>, [<group>]` tells the script to merge all files matching `<regex>` directly into the file `<target>`. The files will be appended to `<target>` in lexiographical order. As with `symlink`, `<target>` may contain tokens of the type `$[1-9]` which will be replaced by the corresponding matching group in the regular expression. It will also collect files by the first matching group (unless `<group>` is specified).

Additionally, you can use regular ruby code, the `@machine` variable containing the machine hostname, and the following blocks:

* `directory <dir> do ...` performs the actions in the block, but only matches files in the specified directory.
* `directories <dirs> do ...` does the same thing, but for multiple directories.

license
=======
The script is licensed under the MIT license (and by sending a pull request with changes to the script you agree to licensing the relevant changes under the MIT license as well - but please add your name to the copyright holder list in your pull request):

> Copyright (C) 2012-2013 Simon Sigurdhsson
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

All content in the subdirectories `common`, `lagrange`, `fserv`, `chomsky` and `contrib` is [effectively public-domain](http://creativecommons.org/publicdomain/zero/1.0/) unless otherwise noted.

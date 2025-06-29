| Website                 | Link                                                                                                                                   |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Git / GitHub cheatsheet | [https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833](https://www.notion.so/Git-GitHub-61bc81766b2e4c7d9a346db3078ce833) |
| Guide to Modularization | [./modular_tfn/readme.md](./modular_tfn/readme.md)                                                                	                   |
| Guide to Mirroring      | [./modular_tfn/mirroring_guide.md](./modular_tfn/mirroring_guide.md)                                              	                   |
| Code                    | [https://github.com/The-Final-Nights/The-Final-Nights](https://github.com/The-Final-Nights/The-Final-Nights)						   |
| Wiki                    | [https://thefinalnights.com/wiki](https://thefinalnights.com/wiki)                                 									   |
| The Final Nights Discord| [https://discord.gg/g85MURQKDK](https://discord.gg/g85MURQKDK)                                                                         |
| Coderbus Discord        | [https://discord.gg/Vh8TJp9](https://discord.gg/Vh8TJp9)                                                                               |

This is the codebase for the World of Darkness 13, a build of a fork of a downstream of a-- in any case...

We are based on the Paradox Interactive World of Darkness(c) gamelines, with administrative oversight determining what we add to our game. 

## DOWNLOADING
[Downloading](.github/DOWNLOADING.md)

[Running on the server](.github/RUNNING_A_SERVER.md)

## Compilation

Find `BUILD.bat` here in the root folder of tgstation, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building tgstation in DreamMaker directly is deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

If you'd like to contribute to this codebase, consider uncommenting line 1 @ _maps\_basemap.dm for faster initialization.

## Getting started

For contribution guidelines refer to the [Guides for Contributors](.github/CONTRIBUTING.md).

For getting started (dev env, compilation) see the HackMD document [here](https://hackmd.io/@tgstation/HJ8OdjNBc#tgstation-Development-Guide).

For overall design documentation see [HackMD](https://hackmd.io/@tgstation).

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI API is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.

The Final Nights is not official World of Darkness material. Portions of the materials are the copyrights and trademarks of Paradox Interactive AB, and are used with permission. All rights reserved. For more information please visit worldofdarkness.com.

![darkpack_logo2](https://github.com/user-attachments/assets/643ce14e-066c-4c81-998f-2e7881f0518d)


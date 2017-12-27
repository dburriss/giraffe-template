# Giraffe Template

![Giraffe](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe/master/giraffe.png)

Giraffe web application template for the `dotnet new` command.

[![NuGet Info](https://buildstats.info/nuget/giraffe-template)](https://www.nuget.org/packages/giraffe-template/)

## Table of contents

- [Installation](#installation)
- [Basics](#basics)
- [Optional parameters](#optional-parameters)
    - [--ViewEngine](#--viewengine)
    - [--IncludeTests](#--includetests)
    - [--UsePaket](#--usepaket)
- [Updating the template](#updating-the-template)
- [Nightly builds and NuGet feed](#nightly-builds-and-nuget-feed)
- [More information](#more-information)
- [License](#license)

## Installation

The easiest way to install the Giraffe template is by running the following command in your terminal:

```
dotnet new -i "giraffe-template::*"
```

This will pull and install the [giraffe-template NuGet package](https://www.nuget.org/packages/giraffe-template/) in your .NET environment and make it available to subsequent `dotnet new` commands.

## Basics

After the template has been installed you can create a new Giraffe web application by simply running `dotnet new giraffe` in your terminal:

```
dotnet new giraffe
```

The Giraffe template only supports the F# language at the moment.

Further information and more help can be found by running `dotnet new giraffe --help` in your terminal.

## Optional parameters

### --ViewEngine

The Giraffe template supports three different view engines:

- `giraffe` (default)
- `razor`
- `dotliquid`

You can optionally specify the `--ViewEngine` parameter (short `-V`) to pass in one of the supported values:

```
dotnet new giraffe --ViewEngine razor
```

The same using the abbreviated `-V` parameter:

```
dotnet new giraffe -V razor
```

If you do not specify the `--ViewEngine` parameter then the `dotnet new giraffe` command will automatically create a Giraffe web application with the default `GiraffeViewEngine` engine.

### --IncludeTests

When creating a new Giraffe web application you can optionally specify the `--IncludeTests` (short `-I`) parameter to automatically generate a default unit test project for your application:

```
dotnet new giraffe --IncludeTests
```

This parameter can also be combined with other parameters:

```
dotnet new giraffe --ViewEngine razor --IncludeTests
```

### --UsePaket

If you prefer [Paket](https://fsprojects.github.io/) for managing your project dependencies you can specify `--UsePaket` (`-U` for short):

```
dotnet new giraffe --UsePaket
```

This will exclude the package references from the *fsproj* file and include the needed *paket.dependencies* and *paket.references* files.

> If you do not run *build.bat* (or *build.sh* on **nix) before running `dotnet restore` you need to manually run `./.paket/paket.exe install` (or `mono ./.paket/paket.exe install`).

See the [Paket documentation](https://fsprojects.github.io/) for more details.

## Updating the template

Whenever there is a new version of the Giraffe template you can update it by re-running the [instructions from the installation](#installation).

You can also explicitly set the version when installing the template:

```
dotnet new -i "giraffe-template::0.11.0"
```

## Nightly builds and NuGet feed

All official Giraffe packages are published to the official and public NuGet feed.

Unofficial builds (such as pre-release builds from the `develop` branch and pull requests) produce unofficial pre-release NuGet packages which can be pulled from the project's public NuGet feed on AppVeyor:

```
https://ci.appveyor.com/nuget/giraffe-template
```

If you add this source to your NuGet CLI or project settings then you can pull unofficial NuGet packages for quick feature testing or urgent hot fixes.

## Contributing

### CI/CD

Whenever making changes to the template be sure that running `build.ps1` can execute successfully. This is used by the build system to verify the project still builds ok.

### Testing template generation

#### Requirements

- Powershell
- [Invoke-Build](https://github.com/nightroman/Invoke-Build)

[See how to install Invoke-Build here](https://github.com/nightroman/Invoke-Build#install-as-module).

#### Testing Specific configurations

You can then test specific configurations by running the default task with the desired options:

```powershell
Invoke-Build -InstallTemplates -IncludeTests -UsePaket
```

##### Options

- **ViewEngine** - Tells the script which view engine to use. Giraffe, Razor, DotLiquid, None. Default: Giraffe
- **IncludeTests** - Tells the script to include creation of a web test project. Default: false
- **UsePaket** - Tells the script to Paket package management instead of Nuget. Default: false
- **InstallTemplates** - Tells the script to install the template before running. Default: false
- **Keep** - Tells the script to keep the generated files even if fails. Default: false

#### Testing all permutations

You can test all the configured permutations of template parameters by running:

```powershell
Invoke-Build Test-Permutations
```

> A warning that this will take a few minutes to complete.

### Updating Paket lock files

If you make changes to the *fsproj* and *paket.dependencies* files, or want to upgrade package versions in the template, you will likely need to update the *paket.lock* files for the different options. This can easily be done by running the **Update-AllPaketLock** task.

```powershell
Invoke-Build Update-AllPaketLock
```

This will generate the *paket.lock* files for the different configurations and copy them into the template.

## More information

For more information about Giraffe, how to set up a development environment, contribution guidelines and more please visit the [main documentation](https://github.com/giraffe-fsharp/Giraffe#table-of-contents) page.

## License

[Apache 2.0](https://raw.githubusercontent.com/giraffe-fsharp/Giraffe.DotLiquid/master/LICENSE)
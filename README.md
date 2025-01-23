# Into to Powershell

## Installing Powershell

> Note for Windows users: Most of what is coverd here should work fine in Powershell 5.1, but getting familar with Powershell 7 is a good idea.

- Windows
  - `winget install --id Microsoft.PowerShell --source winget`
  - [Alternatives](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4)
- MacOS
  - `brew install powershell/tap/powershell`
  - [Alternatives](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.4)
- Linux 
  - Depends on distribution - (see: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.4)


## What makes it special?

In a shell like bash or zsh, we're typically operating on text. Powershell on the other hand operates on objects. Every input and output is an object with properties and methods that we can make use of in our scripts.

`ls -ltr`

``` sh
total 72
drwxr-xr-x  3 wwermager  staff     96 Jan 21 20:44 scripts
-rw-r--r--  1 wwermager  staff  25792 Jan 21 22:07 report.csv
-rw-r--r--  1 wwermager  staff   4916 Jan 21 22:10 README.md
drwxr-xr-x  6 wwermager  staff    192 Jan 21 22:35 datagen
```

`Get-ChildItem`

``` pwsh
    Directory: /Users/wwermager/projects/improving/powershell-101/datagen

UnixMode         User Group         LastWriteTime         Size Name
--------         ---- -----         -------------         ---- ----
drwxr-xr-x  wwermager staff       1/19/2025 20:48           96 data
-rw-r--r--  wwermager staff       1/19/2025 09:11          560 license.env
-rw-r--r--  wwermager staff       1/19/2025 09:39         1329 log-gen.json
-rw-r--r--  wwermager staff       1/19/2025 08:48            0 log-schema.json
```

Each column you see here is a property we can access to filter and control output. This makes the pipe operator espiecially powerful in Powershell.

`Get-ChildItem | Select-Object Size, Name`

The columns above are only a subset of the properties available on the output object of Get-ChildItem. Making use of the `Get-Member` Cmdlet is especially helpful when trying to figure out what properties and methods are available on an object.

`Get-ChildItem | Get-Member`

## Finding Commands

Powershell uses a `Verb-Noun` naming convention for all commands where the verb defines what type of action is being taken on the noun.

A list of standard verbs can be printed out by executing `Get-Verb` Cmdlet.

```
Verb        AliasPrefix Group          Description
----        ----------- -----          -----------
Add         a           Common         Adds a resource to a container, or attaches an item to another item
Clear       cl          Common         Removes all the resources from a container but does not delete the container
Close       cs          Common         Changes the state of a resource to make it inaccessible, unavailable, or unusable
Copy        cp          Common         Copies a resource to another name or to another container
...
```

Knowing what verbs are available can help narrow down the search for a command we might be after. 

For example, the `Get-Command` Cmdlet can be used to find all commands that use the verb `Get`.

`Get-Command -Verb Get`

```
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Get-PSResource                                     1.0.4.1    Microsoft.PowerShell.PSResourceGet
Function        Get-CredsFromCredentialProvider                    2.2.5      PowerShellGet
Function        Get-InstalledModule                                2.2.5      PowerShellGet
Function        Get-InstalledScript                                2.2.5      PowerShellGet
Function        Get-PSRepository                                   2.2.5      PowerShellGet
Cmdlet          Get-Alias                                          7.0.0.0    Microsoft.PowerShell.Utility
Cmdlet          Get-ChildItem                                      7.0.0.0    Microsoft.PowerShell.Management
...
```

Alternatively, using the `Get-Help` Cmdlet can be used to find commands. Doing so this way also provides some context as to what the command does.

For example:

`Get-Help *Convert*`

```
Name                              Category  Module                    Synopsis                                          
----                              --------  ------                    --------                                          
ConvertFrom-ScriptExtent          Function  PowerShellEditorServices… Converts IScriptExtent objects to some common EditorServices types.
ConvertTo-ScriptExtent            Function  PowerShellEditorServices… Converts position and range objects from PowerShellEditorServices to ScriptExte…
ConvertFrom-Csv                   Cmdlet    Microsoft.PowerShell.Uti… Converts object properties in character-separated value (CSV) format into CSV v…
ConvertFrom-Json                  Cmdlet    Microsoft.PowerShell.Uti… Converts a JSON-formatted string to a custom object or a hash table.
ConvertFrom-Markdown              Cmdlet    Microsoft.PowerShell.Uti… Convert the contents of a string or a file to a MarkdownInfo object.
ConvertFrom-StringData            Cmdlet    Microsoft.PowerShell.Uti… Converts a string containing one or more key and value pairs to a hash table.
ConvertTo-Csv                     Cmdlet    Microsoft.PowerShell.Uti… Converts .NET objects into a series of character-separated value (CSV) strings.
ConvertTo-Html                    Cmdlet    Microsoft.PowerShell.Uti… Converts .NET objects into HTML that can be displayed in a Web browser.
ConvertTo-Json                    Cmdlet    Microsoft.PowerShell.Uti… Converts an object to a JSON-formatted string.    
ConvertTo-Xml                     Cmdlet    Microsoft.PowerShell.Uti… Creates an XML-based representation of an object. 
Convert-Path                      Cmdlet    Microsoft.PowerShell.Man… Converts a path from a PowerShell path to a PowerShell provider path.
```

## Writing Scripts

### Types

Powershell has a number of built-in types we can use to store data and control flow of our scripts.

``` pwsh

$creature = "Hag"
$creature.GetType()

$age = 347
$age.GetType()

$health = 254.5
$health.GetType()

$isMonster = $true
$isMonster.GetType()

# Hash Tables and Custom Objects
$hashInventory = @{"Potion of Healing"=4 ; "Scroll of Flying"=1 ; "Gold"=1000}
$hashInventory.GetType()
$hashInventory
$hashInventory | Get-Member

$potion = [PSCustomObject]@{
    Name = "Potion of Healing"
    Quantity = 4
    Value = 50
}
$scroll = [PSCustomObject]@{
    Name = "Scroll of Flying"
    Quantity = 1
    Value = 100
}
$gold = [PSCustomObject]@{
    Name = "Gold"
    Quantity = 1000
    Value = 1
}

$scroll | Get-Member

$inventory = @($item ; $scroll ; $gold)
$inventory | Get-Member
$inventory
```

Should you want to go full object oriented scripting, we can define our own classes as well.

``` pwsh
class Item {
    [string]$Name
    [int]$Quantity
    [int]$Value
}

$loot = [Item]::new()
$loot.Name = "Potion of Healing"
$loot.Quantity = 4
$loot.Value = 50

$loot.GetType()
$loot | Get-Member
$loot
```

### Conditionals

In our scripts, we can make use of typical if else statments as well as switch statements.

``` pwsh
$health = 100
if ($health -gt 0) {
    Write-Host "You are alive!"
} else {
    Write-Host "You are dead!"
}
```



Command-line utility addon to create, list and delete weapon sets.

Usage: `/weaponrack <command> <name>`

Available commands

Save
Creates set with a given name
Usage: `/weaponrack save SetName`

Delete
Delete a given set
Usage: `/weaponrack delete SetName`

List
Lists all sets
Usage: `/weaponrack list`

Once a set is created, it can be included in a macro by using `/equipset SetName`

Motivation: Macros with 2 weapons of the same name won't work correctly. This small tool 
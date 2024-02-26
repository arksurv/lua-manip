# lua-manip
a collection of some usefulish things i've made

# Documentation

## manip

### .init(...)
- Inputs any amount of comma seperated inputs (strings)
- Will load the given function group(s) depending on the inputs
- Current possible inputs are: "debugger", "string", "class"
- Returns: Nothing

## manip.debugger
- Must be loaded with manip.init("debugger")

### .recursivePrint(toPrint, [index])
- Prints an input recursively, printing key value pairs for each table and subtable up to a hard-coded depth limit.
- toPrint: Table or value to print recursively.
- index (optional): Used internally to handle indentation, etc. Check the source if you want to use this.
- Returns: Nothing

### .iterativeComparisons(table, [topLine])
- Compares each value in a table against the other values in the table.
- table: Table to iteratively compare.
- topLine (optional): Boolean, if true will print a top line to the comparisons showing what is being evaluated. Defaults to true.
- Returns: Nothing

## manip.string
- Must be loaded with manip.init("string")

### .split(string, separator)
- Splits a string into an array based on a provided separator string. If the separator string is an empty string, it will return each character of the string to split as a seperate string in the array without a preceeding or trailing empty string.
- string: String to split
- separator: String to separate by
- Returns: Array of strings

## manip.class
- Must be loaded with manip.init("class")

### .new(className, methods, inherits, defaultProperties)
- Creates a new class object from the provided information.
- className: String; must be unique from all other previously created classes
- methods: Table or nil; a table of the methods objects of the class should have (a function called init() will be run upon object creation, provided only one argument; the newly created object)
- inherits: String, array containing classes and/or strings, or nil; Defines classes to inherit methods from. If a method of the same name is defined, it will take precedence over inherited methods. The earlier classes in the array take precedence over the later classes.
- defaultProperties: Table or nil; a table of the default values to set to an object of this class upon creation.
- Returns: A class

### .getAll()
- Returns all of the created classes

### .getClass(className)
- Returns the class with the given className, returns nil if no class exists.

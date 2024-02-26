local manip = {}

local initFunctions
local inits = {}

function manip.init(...)
  local tab = {...}
  
  for _, v in ipairs(tab) do
    if not inits[v] then
      local s = pcall(initFunctions[v])
      if s then
        inits[v] = true
      end
    end
  end
end

-- debugger
local function debuggerInit()
  manip.debugger = {}
  
  function manip.debugger.recursivePrint(tab, d)
    if d == nil then d = 0 end

    local s = ""
    for i = 1,d do
      s = s.." "
    end

    if d > 115 then
      print("MAXIMUM DEPTH REACHED")
      return
    end

    if type(tab) == "table" then
      for k, v in pairs(tab) do
        if type(v) == "table" then
          print(s..tostring(k)..":")
	  manip.debugger.recursivePrint(v, d+1)
        else
          print(s..k,v)
        end
      end
    end
  end

  function manip.debugger.iterativeComparisons(tab, b)
    if b or b == nil then
      print('x', 'y', '==', '<', '>')
    end  

    for i, v in ipairs(tab) do
      for t = (i+1), #tab do
        print(v, tab[t], v == tab[t], v < tab[t], v > tab[t])
      end
    end
  end
end

-- string manip
local function stringInit()
  manip.string = {}

  function manip.string.split(str, sep)
    local parts = {}
    local len, slen = string.len(str), string.len(sep)
    local tmp = 1

    for i = 1, len - slen + 1 do
      if string.sub(str, i, i + slen - 1) == sep then
        table.insert(parts, string.sub(str, tmp, i-1))
        tmp = i + slen
      end
    end

    table.insert(parts, string.sub(str, tmp, len))

    -- if splitting by a blank string, remove the proceeding and preceeding blank strings
    -- this way, splitting by a blank string functions as returning every character
    -- separated into an array
    if slen == 0 then
      table.remove(parts, 1)
      table.remove(parts, #parts)
    end

    return parts
  end
end

-- class system
local function classInit()
  manip.class = {}
  manip.class.__classes = {}

  local classes = manip.class.__classes
  local defaultClassMethods = {}

  function defaultClassMethods.new(self)
    local class = setmetatable(self.__default or {}, self.__mt)

    class.__classname = self.__name

    if class["init"] ~= nil then
      pcall(class["init"], class)
    end
    
    return class
  end

  function manip.class.new(name, methods, inherits, defaultProperties)
    if classes[name] == nil and type(name) == "string" then
      local class, mt = {}, {}

      methods = methods or {}

      if type(defaultProperties) == "table" then
        class.__default = defaultProperties
      end

      class.__name = name

      if type(inherits) == "string" then
        inherits = {manip.class.getClass(inherits)}
      elseif type(inherits) == "table" then
        for i, v in ipairs(inherits) do
          if type(v) == "string" then
            inherits[i] = manip.class.getClass(v)
          end
        end
      end

      class.__inherits = inherits

      if inherits == nil then
        class.__methods = methods
      elseif #inherits == 1 then
        class.__methods = setmetatable(methods, {__index = inherits[1].__methods})
      else
        class.__methods = setmetatable(methods, {
	  __index = function(tab, ind)
	    for _, v in ipairs(class.__inherits) do
              if v.__methods[ind] ~= nil then
                return v.__methods[ind]
              end
            end

            return nil
	  end
        })
      end

      class.__mt = mt
      mt.__index = class.__methods

      local classmt = {}
      classmt.__index = defaultClassMethods

      classes[name] = setmetatable(class, classmt)
      return classes[name]
    else
      error("Could not create class")
    end
  end

  function manip.class.getAll()
    return classes
  end
  
  function manip.class.getClass(name)
    return classes[name]
  end
end

initFunctions = {
  ["debugger"] = debuggerInit,
  ["string"] = stringInit,
  ["class"] = classInit
}

return manip

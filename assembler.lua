--[[
-- Sergio Alejandro Vargas Q. `savargasqu@unal.edu.co`
-- Arquitectura de computadores
-- 2020-I
-- Ensamblador para ISA-13 trabajado en clase
--]]

--[[ NOTA:
--  Traté de comentar cada parte importante del código, si falta algo me avisan.
--  También escribí comentarios sobre como funciona Lua entre corchetes.
--]]

--[[In lua, tables are the only data structure.
-- Lists are also tables.
-- Tables are also a namespace.]]
symbol_table = {}
instruction_list = {} --list of instruction mnemonics
isa = { LODD = '00',
        STOD = '10',
        ADDD = '20',
        SUBD = '30',
        LOCO = '40',
        JPOS = '50',
        JNEG = '60',
        JZER = '70',
        JNZE = '80',
        JUMP = '90',
        INPAC = 'A0',
        OUTAC = 'B0',
        HALT = 'C0'}

--[[ NOTE:
--  It would be convenient if there were two more instructions:
--  `add constant` and `subtract constant`
--  Nothing in the architecture prevents this, and
--  it'd reduce the memory requirements for simple operations (like iterators)
--]]

function main()
  --[[ The arg vector keeps command line arguments
  --  A variable can have a default with the `or` syntax
  --  Lua doesn't shortcut booleans.]]
  local input_filename = arg[1] or 'program.csv'
  --First pass, generates symbol table and instruction list
  parse_file(input_filename)
  print('symbol_table: ' .. format_table(symbol_table)) --For debugging
  --Second pass, replace symbols and write machine code
  local output_filename = arg[2] or nil
  write_machine_code(output_filename)
end --main


function parse_file(file_name)
  local mem_addr = 0
  local tokens = {}
  --[[ With the `in io.lines()` construct, Lua can handle
  --opening and closing the file automatically]]
  for line in io.lines(file_name) do
    --Parse each line of the file
    tokens = parse_line(line)
    --If there is a label, add it to the symbol table
    --with its corresponding memory address (as a hex word)
    if (tokens[1]) ~= '' then
      symbol_table[tokens[1]] = string.format('%02X', mem_addr)
    end --if
    mem_addr = mem_addr + 1 --[[Lua doesn't have `++` or `+=` operators]]

    --Add the rest, instruction and operand, to the instruction list
    add_to_instruction_list(tokens[2], tokens[3])
  end --for
end --fn


function parse_line(inputstr, sep)
  sep = sep or ',' --If no separator is defined, it defaults to ','
  local parsed_tokens = {} --List of substring tokens
  local str = ''
  --Match substrings that are between the separator
  for match in string.gmatch(inputstr, '([%w%s]*)['..sep..']*') do
    --Remove whitespace and turn upper case (to make it case insensitive)
    token = string.upper(string.gsub(match, '%s+', ''))
    table.insert(parsed_tokens, token)
  end --for
  return parsed_tokens
end --fn


function add_to_instruction_list(instruction, operand)
  --Instructions with no operands default to 0
  if operand == '' or operand == nil then
    operand = '00'
  end
  table.insert(instruction_list, {instruction, operand})
end --fn


function write_machine_code(file_name)
  --If a file is provided, write to file, otherwise write to stdout
  if file_name ~= nil then
    file = io.open(file_name, 'w')
    io.output(file)
  end --if

  m_instruction = ''
  --Iterate over the list of instructions
  for _, tuple in pairs(instruction_list) do 
    --instruction, operand = unpack(tuple) --unpack is global in Lua < 5.1 (JIT)
    instruction, operand = table.unpack(tuple) --but it's a method in lua >= 5.2

    --Check that it's an actual instruction and not a variable
    if instruction ~= 'DS' then
      --Place the first part of the code, the instruction
      m_instruction = isa[instruction] or ''
      --Place the second part of the code, the operand memory address
      if symbol_table[operand] ~= nil then --Replace symbol with memory address
        m_instruction = m_instruction .. symbol_table[operand]
      else --It's either a constant or there's no operand (zero)
        m_instruction = m_instruction .. operand
      end --if (symbols)

    else --It's a variable, and variables stored in memory default to zero
      m_instruction = '0000'
    end --if (instructions)
    io.write(m_instruction..'\n') --Will write to file or to stdout
  end

  if file ~= nil then --If the file was opened, it has to be closed as well
    io.close(file)
  end --if
end --fn


-- format_table: Only for debugging
function format_table(table)
  local strf = '{  '
  --[[To iterate a table, there's the `in pairs()` construct ]]
  for k, v in pairs(table) do
      strf =strf..k..': '..v..';  '
  end --for
  strf = strf..'}'
  return strf
end --fn

--[[Lua doesn't have an entry point,
--  main has to be explicitly called from within.]]
main()


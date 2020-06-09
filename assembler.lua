--[[
   Sergio Alejandro Vargas Q. `savargasqu@unal.edu.co`
   Arquitectura de computadores
   2020-I
   Ensamblador para ISA trabajado en clase

   NOTE:
    Traté de comentar cada parte importante del código.
    También escribí varios comentarios sobre como funciona el lenguaje como tal.
--]]

-- NOTE: In lua, tables are the main and only data structure.
-- Tables are incredibly versatile, they can be used as:
symbol_table = {}    -- hash tables
inst_list = {}       -- lists
isa = { LODD = '00', -- namespaces
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
        HALT = 'C0',
        LDIX = 'D0',
        LODI = 'E0',
        STOI = 'F0',
        ADDI = '01',
        SUBI = '02'}

function main()
  --[[NOTE: The `arg` array keeps command line arguments.
  --  Variables can have default values by short-circuiting the `or` operator.]]
  -- FIRST PASS (READ AND PARSE)
  -- If there are no arguments, read from stdin
  local input_filename = arg[1] or stdin
  -- Generate symbol table and instruction list
  parse_file(input_filename)
  -- Print the symbol table to stdin (for debugging)
  print('symbol_table: ' .. format_table(symbol_table))
  --[[For debugging
    for _, pair in pairs(inst_list) do
      print('symbol_table: ' .. format_table(pair))
    end
  --]]
  -- SECOND PASS (FORMAT AND WRITE)
  --If there's no second argument (file), write to stdout
  if arg[2] ~= nil then
    out_stream = io.open(arg[2], 'w')
    io.output(outstream)
  end
  -- Replace symbols and write machine code
  write_machine_code(out_stream)
  --If the file was opened, close it
  if outfile ~= nil then
    io.close(out_stream)
  end
end --main


--[[parse_file: Takes a file (or stream) and reads each line,
--  filling the symbol table and preparing the instruction list accordingly.]]
function parse_file(file_name)
  local mem_addr = 0
  local tokens = {}
  --[[Lua can open and close files with the `in io.lines()` construct]]
  for line in io.lines(file_name) do
    --Parse each line of the file
    tokens = parse_line(line)
    -- Sanitize list. Make sure there are 3 elements
    for i = 1,3 do
      tokens[i] = tokens[i] or ''
    end
    --If there's a label,
    if tokens[1] ~= '' then
     --add it to the symbol table with its address (hex word)
      symbol_table[tokens[1]] = to_hex(mem_addr)
    end -- if label
    mem_addr = mem_addr + 1 --[[Lua doesn't have `++` or `+=` operators]]

  --Add the instruction and operand to the instruction list
  table.insert(inst_list, {tokens[2], tokens[3]})
  end --for
end --fn


--[[write_machine_code: Writes (to the current open stream) the contents of
--  the inst_list as hexadecimal strings, according to the symbol_table.]]
function write_machine_code()
  m_instruction = ''  --String to concatenate mnemonic-operand pairs
  --Iterate over the list of instructions
  for _, tuple in pairs(inst_list) do 
    --[[NOTE: `unpack` is a global function in Lua < 5.1,
    --  but it's a method in lua >= 5.2.]]
    --mnemonic, operand = unpack(tuple) -- Lua 5.1
    mnemonic, operand = table.unpack(tuple) -- Lua 5.3
    is_inst = true     -- is the mnemonic an instruction or a DS?
    --Check instruction
    if mnemonic == '' or mnemonic == 'DS' then
      m_instruction = '----' -- It's a variable
      is_inst = false
    elseif isa[mnemonic] ~= nil then
      m_instruction = isa[mnemonic] -- It's an instruction
    end
    --Check operand
    if is_inst then
      if operand == '' then --There's no operand
        m_instruction = m_instruction .. '00'
      elseif symbol_table[operand] ~= nil then --The operand is a symbol.
        --Replace the symbol with its memory address
        m_instruction = m_instruction .. symbol_table[operand]
      else --It's a constant
        m_instruction = m_instruction .. to_hex(operand)
      end
    end -- is_inst
    --Write instruction to file (or stdout)
    io.write(m_instruction..'\n') 
  end --for inst_list
end --fn


--[[HELPER FUNCTIONS]]


--[[parse_line: Takes a string and returns a list of substrings split
--  according to a separator.]]
function parse_line(inputstr, sep)
  sep = sep or ',' --If no separator is defined, it defaults to ','
  local parsed_tokens = {} --List of substring tokens
  local str = ''
  --FIXME: The regex isn't very clear. Could it be simpler?
  --Match each substring between the separators
  for match in string.gmatch(inputstr, '([%w%s]*)['..sep..']*') do
    --Remove whitespace and turn upper case (to make it case insensitive)
    token = string.upper(string.gsub(match, '%s+', ''))
    table.insert(parsed_tokens, token)
  end --for
  return parsed_tokens
end --fn


--[[to_hex: Takes a number and returns its hexadecimal representation.]]
function to_hex(num)
  return string.format('%02X', num)
end


--[[format_table: Takes a table and returns a formatted string.
--  Only for debugging.]]
function format_table(table)
  -- FIXME: Table output doesn't look that good
  local strf = '{  '
  --[[To iterate a table, there's the `in pairs()` construct]]
  for k, v in pairs(table) do
      strf =strf..k..': '..v..';  '
  end --for
  strf = strf..'}'
  return strf
end --fn


--[[NOTE: Lua doesn't have an entry point,
--  main has to be called explicitly.]]
main()


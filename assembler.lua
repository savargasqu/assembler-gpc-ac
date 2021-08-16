--[[
   Sergio Alejandro Vargas `savargasqu@unal.edu.co`
   Arquitectura de computadores
   2020-I
   Ensamblador para ISA trabajado en clase
--]]

local ISA = {
    LODD  = "00",
    STOD  = "10",
    ADDD  = "20",
    SUBD  = "30",
    LOCO  = "40",
    JPOS  = "50",
    JNEG  = "60",
    JZER  = "70",
    JNZE  = "80",
    JUMP  = "90",
    INPAC = "A0",
    OUTAC = "B0",
    HALT  = "C0",
    LDIX  = "D0",
    LODI  = "E0",
    STOI  = "F0",
    ADDI  = "01",
    SUBI  = "02"
}

function main()
    local m_code = to_machine_code(parse(arg[1]))

    if arg[2] then
        local out = io.open(arg[2], "w")
        out:write(m_code)
        out:close()
    else
        print(m_code)
    end
end


function parse(input)
    local instructions = {}
    local symbol_table = {}
    local mem_addr = 0

    for line in io.lines(input) do
        local tokens = split_string(line)

        -- Make sure there are 3 elements.
        for i = 1,3 do
            tokens[i] = tokens[i] or ""
        end

        -- If there's a label, add it to the symbol table.
        if tokens[1] ~= "" then
            symbol_table[tokens[1]] = hex(mem_addr)
        end

        -- Add the instruction and operand to the instructions list.
        table.insert(instructions, {tokens[2], tokens[3]})

        mem_addr = mem_addr + 1
    end

    return instructions, symbol_table
end


function to_machine_code(instructions, symbol_table)
    local m_code = ""
    local m_instr, is_instr;

    for _, tuple in pairs(instructions) do 
        local mnemonic, operand = tuple[1], tuple[2]

        -- Check instruction
        if ISA[mnemonic] then
            m_instr = ISA[mnemonic]
            is_instr = true
        elseif mnemonic == "" or mnemonic == "DS" then
            m_instr = "----"
            is_instr = false
        end

        -- Check operand
        if is_instr then
            if operand == "" then --there's no operand
                m_oper = "00"
            elseif symbol_table[operand] then -- the operand is a symbol
                m_oper = symbol_table[operand]
            else --the operand is a constant
                m_oper = hex(operand)
            end
        else
            m_oper = ""
        end

        m_code = m_code .. m_instr .. m_oper .. "\n"
    end

    return m_code
end


function split_string(str, sep)
    sep = sep or ","
    local substrings = {}
    for s in str:gmatch("[^" .. sep .. "]+") do
        table.insert(substrings, s:gsub("%s+", ""):upper())
    end
    return substrings
end


function hex(n)
    return ("%02X"):format(n)
end


main()


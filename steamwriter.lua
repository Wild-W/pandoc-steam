-- This is a sample custom writer for pandoc.  It produces output
-- that is very similar to that of pandoc's HTML writer.
-- There is one new feature: code blocks marked with class 'dot'
-- are piped through graphviz and images are included in the HTML
-- output using 'data:' URLs. The image format can be controlled
-- via the `image_format` metadata field.
--
-- Invoke with: pandoc -t sample.lua
--
-- Note:  you need not have lua installed on your system to use this
-- custom writer.  However, if you do have lua installed, you can
-- use it to test changes to the script.  'lua sample.lua' will
-- produce informative error messages if your code contains
-- syntax errors.

-- As of Pandoc 3.0
function Writer (doc, opts)
  PANDOC_DOCUMENT = doc
  PANDOC_WRITER_OPTIONS = opts
  loadfile(PANDOC_SCRIPT_FILE)()
  return pandoc.write_classic(doc, opts)
end

local pipe = pandoc.pipe
local stringify = (require 'pandoc.utils').stringify

-- The global variable PANDOC_DOCUMENT contains the full AST of
-- the document which is going to be written. It can be used to
-- configure the writer.
local meta = PANDOC_DOCUMENT.meta

-- Choose the image format based on the value of the
-- `image_format` meta value.
local image_format = meta.image_format and stringify(meta.image_format) or 'png'
local image_mime_type = ({
    jpeg = 'image/jpeg',
    jpg = 'image/jpeg',
    gif = 'image/gif',
    png = 'image/png',
    svg = 'image/svg+xml'
})[image_format] or error('unsupported image format `' .. image_format .. '`')

-- Character escaping
local function escape(s, in_attribute) -- TODO
    return s
    -- return s:gsub('[<>&"\']', function(x)
    --     if x == '<' then
    --         return '&lt;'
    --     elseif x == '>' then
    --         return '&gt;'
    --     elseif x == '&' then
    --         return '&amp;'
    --     elseif in_attribute and x == '"' then
    --         return '&quot;'
    --     elseif in_attribute and x == "'" then
    --         return '&#39;'
    --     else
    --         return x
    --     end
    -- end)
end

-- Helper function to convert an attributes table into
-- a string that can be put into HTML tags.
-- local function attributes(attr)
--     local attr_table = {}
--     for x, y in pairs(attr) do
--         if y and y ~= '' then
--             table.insert(attr_table, ' ' .. x .. '="' .. escape(y, true) .. '"')
--         end
--     end
--     return table.concat(attr_table)
-- end

-- Table to store footnotes, so they can be included at the end.
local notes = {}

-- Blocksep is used to separate block elements.
function Blocksep() return '\n' end

-- This function is called once for the whole document. Parameters:
-- body is a string, metadata is a table, variables is a table.
-- This gives you a fragment.  You could use the metadata table to
-- fill variables in a custom lua template.  Or, pass `--template=...`
-- to pandoc, and pandoc will do the template processing as usual.
function Doc(body, metadata, variables)
    local buffer = {}
    local function add(s) table.insert(buffer, s) end
    add(body)
    if #notes > 0 then
        add('<ol class="footnotes">')
        for _, note in pairs(notes) do add(note) end
        add('</ol>')
    end
    return table.concat(buffer, '\n') .. '\n'
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s) return escape(s) end

function Space() return ' ' end

function SoftBreak() return '\n' end

function LineBreak() return '\n' end

function Emph(s) return '[i]' .. s .. '[/i]' end

function Strong(s) return '[b]' .. s .. '[/b]' end

local subscript
local superscript

function Subscript(s)
    local result = ''
    if not subscript then
        subscript = {
            ['0'] = '₀',
            ['1'] = '₁',
            ['2'] = '₂',
            ['3'] = '₃',
            ['4'] = '₄',
            ['5'] = '₅',
            ['6'] = '₆',
            ['7'] = '₇',
            ['8'] = '₈',
            ['9'] = '₉',
            a = 'ₐ',
            e = 'ₑ',
            h = 'ₕ',
            i = 'ᵢ',
            k = 'ₖ',
            l = 'ₗ',
            m = 'ₘ',
            n = 'ₙ',
            o = 'ₒ',
            p = 'ₚ',
            r = 'ᵣ',
            s = 'ₛ',
            t = 'ₜ',
            u = 'ᵤ',
            v = 'ᵥ',
            x = 'ₓ',
            -- TODO Add greek symbols
        }
    end
    for i = 1, #s do
        local c = s:sub(i,i)
        result = result .. (subscript[c] or c)
    end
    return result
end

function Superscript(s)
    local result = ''
    if not superscript then
        superscript = {
            ['0'] = '⁰',
            ['1'] = '¹',
            ['2'] = '²',
            ['3'] = '³',
            ['4'] = '⁴',
            ['5'] = '⁵',
            ['6'] = '⁶',
            ['7'] = '⁷',
            ['8'] = '⁸',
            ['9'] = '⁹',
            a = 'ᵃ',
            b = 'ᵇ',
            c = 'ᶜ',
            d = 'ᵈ',
            e = 'ᵉ',
            f = 'ᶠ',
            g = 'ᵍ',
            h = 'ʰ',
            i = 'ⁱ',
            j = 'ʲ',
            k = 'ᵏ',
            l = 'ˡ',
            m = 'ᵐ',
            n = 'ⁿ',
            o = 'ᵒ',
            p = 'ᵖ',
            r = 'ʳ',
            s = 'ˢ',
            t = 'ᵗ',
            u = 'ᵘ',
            v = 'ᵛ',
            w = 'ʷ',
            x = 'ˣ',
            y = 'ʸ',
            z = 'ᶻ',
            A = 'ᴬ',
            B = 'ᴮ',
            D = 'ᴰ',
            E = 'ᴱ',
            G = 'ᴳ',
            H = 'ᴴ',
            I = 'ᴵ',
            J = 'ᴶ',
            K = 'ᴷ',
            L = 'ᴸ',
            M = 'ᴹ',
            N = 'ᴺ',
            O = 'ᴼ',
            P = 'ᴾ',
            R = 'ᴿ',
            T = 'ᵀ',
            U = 'ᵁ',
            V = 'ⱽ',
            W = 'ᵂ',
            -- TODO Add greek symbols
        }
    end
    for i = 1, #s do
        local c = s:sub(i,i)
        result = result .. (superscript[c] or c)
    end
    return result
end

function SmallCaps(s)
    return '<span style="font-variant: small-caps;">' .. s .. '</span>'
end

function Strikeout(s) return '[strike]' .. s .. '[/strike]' end

function Link(s, tgt, tit, attr)
    return '[url=' .. escape(tgt, true) .. ']' .. s .. '[/url]'
end

function Image(s, src, tit, attr)
    return '[img]' .. escape(src, true) .. '[/img]'
end

function Code(s, attr)
    return '[noparse]' .. escape(s) .. '[/noparse]'
end

function InlineMath(s) return '\\(' .. escape(s) .. '\\)' end

function DisplayMath(s) return '\\[' .. escape(s) .. '\\]' end

function SingleQuoted(s) return '\'' .. s .. '\'' end

function DoubleQuoted(s) return '"' .. s .. '"' end

function Note(s)
    local num = #notes + 1
    -- insert the back reference right before the final closing tag.
    s = string.gsub(s, '(.*)</',
                    '%1 <a href="#fnref' .. num .. '">&#8617;</a></')
    -- add a list item with the note to the note table.
    table.insert(notes, '<li id="fn' .. num .. '">' .. s .. '</li>')
    -- return the footnote reference, linked to the note.
    return '<a id="fnref' .. num .. '" href="#fn' .. num .. '"><sup>' .. num ..
               '</sup></a>'
end

function Span(s, attr)
    return s --'<span' .. attributes(attr) .. '>' .. s .. '</span>'
end

function RawInline(format, str)
    if format == 'html' then
        return str
    else
        return ''
    end
end

function Cite(s, cs)
    local ids = {}
    for _, cit in ipairs(cs) do table.insert(ids, cit.citationId) end
    return '<span class="cite" data-citation-ids="' .. table.concat(ids, ',') ..
               '">' .. s .. '</span>'
end

function Plain(s) return s end

function Para(s) return s end

-- lev is an integer, the header level.
function Header(lev, s, attr)
    if lev > 3 then lev = 3 end
    return '[h' .. lev .. ']' .. s .. '[/h' .. lev .. ']'
end

function BlockQuote(s) return '[quote]\n' .. s .. '\n[/quote]' end

function HorizontalRule() return "[hr][/hr]" end

function LineBlock(ls)
    return '<div style="white-space: pre-line;">' .. table.concat(ls, '\n') .. '</div>'
end

function CodeBlock(s, attr)
    -- If code block has class 'dot', pipe the contents through dot
    -- and base64, and include the base64-encoded png as a data: URL.
    -- if attr.class and string.match(' ' .. attr.class .. ' ', ' dot ') then
    --     local img = pipe('base64', {}, pipe('dot', {'-T' .. image_format}, s))
    --     return '<img src="data:' .. image_mime_type .. ';base64,' .. img ..
    --                '"/>'
    --     -- otherwise treat as code (one could pipe through a highlighter)
    -- else
    return '[code]' .. escape(s) .. '[/code]'
    -- end
end

function BulletList(items)
    local buffer = {}
    for _, item in pairs(items) do
        table.insert(buffer, '[*]' .. item)
    end
    return '[list]' .. table.concat(buffer, '\n') .. '[/list]'
end

function OrderedList(items)
    local buffer = {}
    for _, item in pairs(items) do
        table.insert(buffer, '[*]' .. item)
    end
    return '[olist]' .. table.concat(buffer, '\n') .. '[/olist]'
end

function DefinitionList(items)
    local buffer = {}
    for _, item in pairs(items) do
        local k, v = next(item)
        table.insert(buffer, '[b]' .. k .. '[/b]\n[list][*]' ..
                         table.concat(v, '\n[*]') .. '[/list]')
    end
    return table.concat(buffer, '\n')
end

-- Convert pandoc alignment to something HTML can use.
-- align is AlignLeft, AlignRight, AlignCenter, or AlignDefault.
-- local function html_align(align)
--     if align == 'AlignLeft' then
--         return 'left'
--     elseif align == 'AlignRight' then
--         return 'right'
--     elseif align == 'AlignCenter' then
--         return 'center'
--     else
--         return 'left'
--     end
-- end

function CaptionedImage(src, tit, caption, attr)
    local result = ''
    result = result .. Image('', src)
    if #caption > 0 then
        local ecaption = escape(caption)
        result = result .. '\n[i]' .. ecaption .. '[/i]'
    end
    return result
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
    local buffer = {}
    local function add(s) table.insert(buffer, s) end
    add('[table]')
    -- if caption ~= '' then add('<caption>' .. escape(caption) .. '</caption>') end
    -- if widths and widths[1] ~= 0 then
    --     for _, w in pairs(widths) do
    --         add('<col width="' .. string.format('%.0f%%', w * 100) .. '" />')
    --     end
    -- end
    local header_row = {}
    local empty_header = true
    for i, h in pairs(headers) do
        -- local align = html_align(aligns[i])
        table.insert(header_row, '[th]' .. h .. '[/th]')
        empty_header = empty_header and h == ''
    end
    if not empty_header then
        add('[tr]')
        for _, h in pairs(header_row) do add(h) end
        add('[/tr]')
    end
    -- local class = 'even'
    for _, row in pairs(rows) do
        -- class = (class == 'even' and 'odd') or 'even'
        add('[tr]')
        for i, c in pairs(row) do
            add('[td]' .. c .. '[/td]')
        end
        add('[/tr]')
    end
    add('[/table]')
    return table.concat(buffer, '\n')
end

function RawBlock(format, str)
    if format == 'html' then
        return str
    else
        return ''
    end
end

function Div(s, attr) return s end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index = function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n", key))
    return function() return '' end
end
setmetatable(_G, meta)

simplycv = simplycv or {}

local GLUE = node.id("glue")
local DISC = node.id("disc")
local SPACE_SUBTYPES = { [0] = true, [13] = true, [14] = true }

-- Binds the last two words of a paragraph so neither a lone word nor the tail of a
-- hyphenated word can sit alone on the final line.
local function tie_last_words(head)
  local n = node.tail(head)
  local discs = {}
  while n do
    if n.id == DISC then
      discs[#discs + 1] = n
    elseif n.id == GLUE and SPACE_SUBTYPES[n.subtype] then
      for _, disc in ipairs(discs) do
        disc.penalty = 10000
      end
      if n.stretch_order == 0 then
        local penalty = node.new("penalty")
        penalty.penalty = 10000
        head = node.insert_before(head, n, penalty)
      end
      break
    end
    n = n.prev
  end
  return head
end
luatexbase.add_to_callback("pre_linebreak_filter", tie_last_words, "simplycv.tie")

local function luminance(hex)
  local function channel(from)
    local c = tonumber(hex:sub(from, from + 1), 16) / 255
    if c <= 0.03928 then return c / 12.92 end
    return ((c + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * channel(1) + 0.7152 * channel(3) + 0.0722 * channel(5)
end

-- WCAG AA for body text against a white page.
function simplycv.check_contrast(hex)
  local ratio = 1.05 / (luminance(hex) + 0.05)
  if ratio < 4.5 then
    luatexbase.module_warning("simplycv",
      string.format("accent %s has %.1f:1 contrast on white; 4.5:1 is the readable minimum", hex, ratio))
  end
end

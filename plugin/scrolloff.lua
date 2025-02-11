local DEFAULT_SCROLLOFF_PERCENTAGE = 0.5

local function get_scrolloff_percentage()
  if vim.g.scrolloff_percentage == nil then
    vim.g.scrolloff_percentage = vim.g.scrolloff_percentage or DEFAULT_SCROLLOFF_PERCENTAGE
  end
  vim.validate(
    "g:scrolloff_percentage",
    vim.g.scrolloff_percentage,
    function(value) return type(value) == "number" and value >= 0.0 and value <= 1.0 end,
    "number between 0 and 1"
  )

  return vim.g.scrolloff_percentage
end

local function calculate_scrolloff(percentage) return math.floor(vim.o.lines * percentage) end

local scrolloff_percentage = get_scrolloff_percentage()
vim.opt.scrolloff = calculate_scrolloff(scrolloff_percentage)

vim.api.nvim_create_autocmd({ "WinResized" }, {
  group = vim.api.nvim_create_augroup("smart-scrolloff", { clear = true }),
  callback = function() vim.opt.scrolloff = calculate_scrolloff(vim.g.scrolloff_percentage) end,
})

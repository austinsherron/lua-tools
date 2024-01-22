--- Contains utility methods that wrap function calls and perform specific actions when the
--- functions raise errors.
---
---@class OnErr
local OnErr = {}

--- On error, returns false.
---
---@param f fun(): any?: the function that might throw an error
---@param ... any?: args to pass to f
---@return boolean: true if the function completes w/out error, false otherwise
---@return any?: the result of f, if any
function OnErr.as_bool(f, ...)
  return pcall(f, ...)
end

--- On error, returns a substitute value.
---
---@generic T
---@param f fun(...): T|nil: the function that might throw an error
---@param sub Callable: the value to substitute on error
---@param ... any?: args to pass to f
---@return T: the return value of f, or the return value of sub, if f encounters errors
---@return string|nil: the response from any errors encountered calling f, if any
function OnErr.substitute(f, sub, ...)
  local ok, res = pcall(f, ...)

  if ok then
    return res
  end

  return sub(), res
end

return OnErr

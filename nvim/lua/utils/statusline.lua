---@diagnostic disable: lowercase-global

function wrap(string)
    return ' ' .. string .. ' '
end

function wrap_left(string)
    return ' ' .. string .. ' '
end

function wrap_right(string)
    return ' ' .. string .. ' '
end

function provide(provider, wrapper)
    return function(component, opts)
        return (wrapper(provider(component, opts)))
    end
end

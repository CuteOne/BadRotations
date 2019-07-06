if br.api == nil then br.api = {} end
br.api.ui = function(option)
    option.checked = function(thisOption)
        if thisOption == nil then return false end
        return isChecked(thisOption)
    end
    option.value = function(thisOption)
        if thisOption == nil then return 0 end
        return getOptionValue(thisOption)
    end
end
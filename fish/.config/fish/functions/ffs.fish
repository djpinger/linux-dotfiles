function ffs --description 'Find file whose name starts with a given string'
    /usr/bin/find . -name "$argv*"
end

function _make_or_just
    if command -q just; and string match -iqr -- justfile (pwd)/*
        echo just
    else
        echo make
    end
end

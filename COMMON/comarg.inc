; returns the next whitespace separated program parameter
; in a separate buffer for it
get_next_parameter proc
        current_loc dw 0 ; persistent offset counter
        ret
get_next_parameter endp

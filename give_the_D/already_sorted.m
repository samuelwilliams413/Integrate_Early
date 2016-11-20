function [yes_no] = already_sorted(sorted, the_D)
    index = the_D(1);
    if(sorted.s(index) == 1)
        yes_no =  true;
        return;
    end
    yes_no = false;

end
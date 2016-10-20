function [xv1, yv1, xv2, yv2] = get_quad(i, trackingin, matches);

    x = trackingin(i, 1) + 0.5 * trackingin(i, 3);
    y = trackingin(i, 2) + 0.5 * trackingin(i, 4);
    m = (matches(i,12) - matches(i,10))/(matches(i,11) - matches(i,9));
    m = tand(atand(m) );

    off = y - m*x;
    hold on
%     ps % points inside
    x = 0:1:2000;
    y = m*x+off;
    % plot(x, y);

    BoR(1) = trackingin(i, 1);
    ToL(1) = trackingin(i, 1) + trackingin(i, 3);
    BoR(2) = m*BoR(1) + off;
    ToL(2) = m*ToL(1) + off;


    TL(1) = trackingin(i, 1);
    TL(2) = trackingin(i, 2);

    TR(1) = trackingin(i, 1) + trackingin(i, 3);
    TR(2) = trackingin(i, 2);

    BR(1) = trackingin(i, 1) + trackingin(i, 3);
    BR(2) = trackingin(i, 2) + trackingin(i, 4);

    BL(1) = trackingin(i, 1);
    BL(2) = trackingin(i, 2) + trackingin(i, 4);

    xv1 = [BoR(1) TL(1) TR(1) ToL(1) BoR(1)];
    yv1 = [BoR(2) TL(2) TR(2) ToL(2) BoR(2)];

    xv2 = [BoR(1) BL(1) BR(1) ToL(1) BoR(1)];
    yv2 = [BoR(2) BL(2) BR(2) ToL(2) BoR(2)];


    if BoR(2) > (trackingin(i, 2) + trackingin(i, 4))
        BoR(2) = (trackingin(i, 2) + trackingin(i, 4));
        BoR(1) = (BoR(2) - off) / m;

        ToL(2) = (trackingin(i, 2));
        ToL(1) = (ToL(2) - off) / m;


        xv1 = [BoR(1) BL(1) TL(1) ToL(1) BoR(1)];
        yv1 = [BoR(2) BL(2) TL(2) ToL(2) BoR(2)];

        xv2 = [BoR(1) BR(1) TR(1) ToL(1) BoR(1)];
        yv2 = [BoR(2) BR(2) TR(2) ToL(2) BoR(2)];


    end

    if ToL(2) > (trackingin(i, 2) + trackingin(i, 4))
        ToL(2) = (trackingin(i, 2) + trackingin(i, 4));
        ToL(1) = (ToL(2) - off) / m;

        BoR(2) = (trackingin(i, 2));
        BoR(1) = (BoR(2) - off) / m;
    end


    plot(BoR(1), BoR(2),'r+','LineWidth',2); % B || L
    plot(TL(1), TL(2),'b*','LineWidth',2); % TL
    plot(TR(1), TR(2),'bo','LineWidth',2); % TR
    plot(ToL(1), ToL(2),'r*','LineWidth',2); % T || L
    plot(BL(1), BL(2),'yo','LineWidth',2); % BL
    plot(BR(1), BR(2),'y*','LineWidth',2); % BR


end
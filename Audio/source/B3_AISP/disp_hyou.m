Dist(1) = sqrt( sum( (Jan_Goo_PowX_dB(:,1) - Jan_Goo_PowX_dB(:,2) ) .^2 ) );
Dist(2) = sqrt( sum( (Jan_Goo_PowX_dB(:,1) - Jan_Chk_PowX_dB(:,2) ) .^2 ) );
Dist(3) = sqrt( sum( (Jan_Goo_PowX_dB(:,1) - Jan_Par_PowX_dB(:,2) ) .^2 ) );
Dist(4) = sqrt( sum( (Jan_Chk_PowX_dB(:,1) - Jan_Goo_PowX_dB(:,2) ) .^2 ) );
Dist(5) = sqrt( sum( (Jan_Chk_PowX_dB(:,1) - Jan_Chk_PowX_dB(:,2) ) .^2 ) );
Dist(6) = sqrt( sum( (Jan_Chk_PowX_dB(:,1) - Jan_Par_PowX_dB(:,2) ) .^2 ) );
Dist(7) = sqrt( sum( (Jan_Par_PowX_dB(:,1) - Jan_Goo_PowX_dB(:,2) ) .^2 ) );
Dist(8) = sqrt( sum( (Jan_Par_PowX_dB(:,1) - Jan_Chk_PowX_dB(:,2) ) .^2 ) );
Dist(9) = sqrt( sum( (Jan_Par_PowX_dB(:,1) - Jan_Par_PowX_dB(:,2) ) .^2 ) );

disp(Dist);
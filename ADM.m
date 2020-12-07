function [ADMout] = ADM(sig_in, Delta, td, ts)
% INPUT -----------------------------------------------------------------
%   sig_in: Input signal in vector format
%   Delta: Minimum step size
%   td: The original sampling period of the input signal, sig_in
%   ts: The required sampling period for ADM output
% OUTPUT ----------------------------------------------------------------
%   ADMout:Encoded vector of output signal


    if (round(ts/td) >= 2)
        M = round(ts/td);    %Nearest integer
        xsig = interp(sig_in,M);
        Lxsig = length(xsig);
        
        cnt1 = 0;   
        cnt2 = 0;  
        sum = 0;
        for i=1:Lxsig
            
            if (xsig(i) == sum)
            elseif (xsig(i) > sum)
                if (cnt1 < 2)
                    sum = sum + Delta;  %Step up by Delta
                elseif (cnt1 == 2)
                    sum = sum + 2*Delta;    %Double the step size after
                                            %first two increase
                elseif (cnt1 == 3)
                    sum = sum + 4*Delta;    %Double step size
                else
                    sum = sum + 8*Delta; %Still double and then stop 
                                            
                end
                if (sum < xsig(i))
                    cnt1 = cnt1 + 1;
                else
                    cnt1 = 0;
                end
            else
                if (cnt2 < 2)
                    sum = sum - Delta;
                elseif (cnt2 == 2)
                    sum = sum - 2*Delta;
                elseif (cnt2 == 3)
                    sum = sum - 4*Delta;
                else
                    sum = sum - 8*Delta;
                end
                if (sum > xsig(i))
                    cnt2 = cnt2 + 1;
                else
                    cnt2 = 0;
                end
            end
             D(Lxsig)= mean(abs(xsig - sum).^2);
            SQNR(Lxsig-1)=mean(xsig.^2)/D(Lxsig);
            SQNR(Lxsig-1)=10*log10(SQNR(Lxsig-1));
            ADMout(((i-1)*M + 1):(i*M)) = sum;
           
        end
    end
fprintf('To SQNR ths ADM einai %d \n',SQNR(Lxsig-1));
figure;
plot(ADMout,'-b','LineWidth',2);
title(['ADM,Delta= ',num2str(Delta)]);
ylabel('Signal')
xlabel('Iterations')
grid on;
input=randsrc(10^5,1,[0 1]);
for SNR=0:2:20
    i=i+1;
    [~,SER,BER]=MPAM(input,4,SNR,'bin');
    SERFINAL4(i)=SER;
    BERFINAL4(i)=BER;
    [~,SER,BER]=MPAM(input,8,SNR,'gray');
    SERFINAL8(i)=SER;
    BERFINAL8(i)=BER;
    [~,SER,BER]=MPAM(input,8,SNR,'bin');
    SERFINAL8bin(i)=SER;
    BERFINAL8bin(i)=BER;
end
figure
plot(0:2:20,BERFINAL4,'-b','LineWidth',2);
hold on;
plot(0:2:20,BERFINAL8,'-r','LineWidth',2);
legend('4PAM','8PAM');
hold off;
title('BER FOR 4PAM AND 8PAM');
xlabel('SNR');
ylabel('BER');

figure
plot(0:2:20,SERFINAL4,'-b','LineWidth',2);
hold on;
plot(0:2:20,SERFINAL8,'-r','LineWidth',2);
legend('4PAM','8PAM');
hold off;
title('SER FOR 4PAM AND 8PAM');
xlabel('SNR');
ylabel('SER');
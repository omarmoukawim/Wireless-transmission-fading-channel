
clc;
clear all;
close all;

EbNoValues = 0:2:18;

% define stop parameters
maxNumErrs = 1e3;
maxNumBits = 1e5;

% solve the model for different Transmit power value

err0 = [];

h = waitbar(0,'Calculating BER values');


for i=1:length(EbNoValues)
    
    EbNo = EbNoValues(i); % scaling the constellation radius
    
    waitbar(i/length(EbNoValues),h,sprintf('Solving model for Eb/N0 = %d dB...', EbNoValues(i)));
    
    sim('BPSK_Rayleigh_FLAT_FLAT.slx');
    
    err0 = [err0 ErrorVec0(1)];
    
end

close(h)

ber_theory = berfading(EbNoValues,'psk',2,1);

EbNoValues_awgn = 0:1:7;
ber_awgn = berawgn(EbNoValues_awgn,'psk',2,'nondiff');

figure

xlabel('Eb/N_0')
ylabel('Average BER')


semilogy(EbNoValues,err0,'pk','MarkerSize',10)
hold on
yline(1e-2,'-','TARGET BER')

semilogy(EbNoValues,ber_theory,'--b','LineWidth',1.5)
grid on

figure
semilogy(EbNoValues_awgn,ber_awgn,'-b','LineWidth',1.5)
grid on

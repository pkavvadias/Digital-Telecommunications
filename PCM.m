function [xq,centers,D] = PCM(x,N,min,max) 
% INPUT -----------------------------------------------------------------
%   x: Input signal in vector format
%   N: Number of bits 
%   min: Minimum acceptable value of input signal
%   max: Maximum acceptable value of input signal
% OUTPUT ----------------------------------------------------------------
%   xq: Encoded vector of output signal
%   centers: Centers of quantization segments
%   D: Vector of signal's distortion at every repetition  
% -----------------------------------------------------------------------

% Number of bits used.
v = N;
% Levels of quantization.
quant_levels = 2^v;
% Initialization of vector xq.
xq = zeros(length(x),1);
% Quantization step.
quant_step = (abs(min)+max)/quant_levels;
% Calculation of centers.
centers = zeros(quant_levels,1); 
for i=1:quant_levels
    centers(i) = max-(2*(i-1)+1)*(quant_step/2);
end
% Loop for Lloyd-Max.
T = zeros((quant_levels+1),1);
counter = 1; 
previous_distortion = 0; 
while 1
    %Calculation of new segments' limits.
    T(1) = max; % Higher level limit.
    for i=2:quant_levels % Middle levels.
        T(i) = (centers(i)+centers(i-1))/2;
    end
    T(quant_levels+1) = min; % Lower level limit.
    
    %Output signal
    q_max_value = 1; q_min_value = quant_levels;
    for i=1:length(x)
        if (x(i) >= max)
            xq(i) = q_max_value;
        elseif (x(i) <= min)
            xq(i) = q_min_value;
        else
            for n=1:quant_levels
                if ((x(i) <= T(n)) && (x(i) > T(n+1)))
                    xq(i) = n;
                end
            end
        end
    end
    
    % Check if there are any zeros.
    if (all(xq)) % If not, calculate the distortion.
        D(counter) = mean((x-centers(xq)).^2); 
    end
    SQNR(counter)=mean(x.^2)/D(counter);
    %Criterion check. If fulfilled, stop the loop.
    difference = abs(D(counter)-previous_distortion);
    if (difference < eps('single')&&N<=4)
        break;
    elseif (difference < eps()&&N>4)
        break;
    else % Else store distortion for the next comparison.
        previous_distortion = D(counter);
    end
    
    %New levels of quantization.
    temp_sum = zeros(quant_levels,1);
    temp_counter = zeros(quant_levels,1); 
    for n=1:quant_levels
        for i=1:length(x)
            % Check if x(i) belongs to n level.
            if (x(i) <= T(n) && x(i) > T(n+1))
                temp_sum(n) = temp_sum(n) + x(i);
                temp_counter(n) = temp_counter(n) + 1;
            % If x(i) is greater than max_value.
            elseif ((x(i) > T(n)) && (n == 1))
                temp_sum(n) = temp_sum(n) + T(n);
                temp_counter(n) = temp_counter(n) + 1;
            % If x(i) is smaller than min_value.
            elseif ((x(i) < T(n+1)) && (n == quant_levels))
                temp_sum(n) = temp_sum(n) + T(n+1);
                temp_counter(n) = temp_counter(n) + 1;
            end
        end
        % Calculating the new center for n level.
        if (temp_counter(n) > 0) % If greater than zero, calculate.
            centers(n) = temp_sum(n)/temp_counter(n);
        end
        
    end
     
    counter = counter + 1;
end
stoixeio = unique(xq);


[emfaniseis,~] = hist(xq,stoixeio);

pithanotita =(emfaniseis/length(xq)) ;
     
Entropia = -pithanotita*log2(pithanotita)';

fprintf('H entropia gia N = %d einai %d \n',N,Entropia);
figure;
plot(SQNR,'-b','LineWidth',2);
title(['PCM,N = ',num2str(N),'bits']);
ylabel('SQNR(db)')
xlabel('Iterations')
grid on;

figure;
plot(xq,'-b','LineWidth',2);
title(['PCM,N = ',num2str(N),'bits']);
ylabel('Quantized Signal')
hold off;
grid on;
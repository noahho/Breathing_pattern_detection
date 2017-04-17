function gen_acc = generateTestData(acc)
    % DISTORTIONS
    sec = randi([0 size(acc, 1)],1,ceil(size(acc, 1)/40));
    sec = sort(sec);
    strength = rand(1,ceil(size(acc, 1)/40)) - 0.5;
    
    I = 1;
    gen_acc = [];
    for K = [1:size(acc, 1)]
        r = rand(1,1) - 0.5 + strength(I) * 1.5;
        if (I < length(sec) && K > sec(I))
            I = I + 1;
        end
        
        if r > 0.5
        elseif r < -0.5
            gen_acc = [gen_acc; acc(K, :); acc(K, :)];
        else
            gen_acc = [gen_acc; acc(K, :)];
        end
    end
    
    % NOISE
    lastchange = 0;
    noise = zeros(size(gen_acc, 1), size(gen_acc, 2));
    s = 0;
    for K = [1:size(gen_acc, 1)]
        change = normrnd(lastchange, 0.05);
        
        if (abs(lastchange) > 0) % save value
            noise(K, 4) = change * s;
            lastchange = change;
        end    
        
        if (abs(change) > 0.30) % deactivate
            lastchange = 0;
            noise(K) = 0;
        elseif (abs(change) > 0.11 && lastchange == 0) % activate
            lastchange = change;
            s = rand(1,1);
        end
       
    end
    gen_acc = gen_acc + noise * 10;
end
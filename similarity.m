function s = similarity(inputs, targets)
    s = zeros(15, size(inputs,2));
    
    for i=1:15
       mask = (targets == i);
       class = inputs(mask,:);
       
       s(i,:) = var(class);
    end
end
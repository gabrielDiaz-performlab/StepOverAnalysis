function trialIndex = extractTrialIndex(TrialType)
    
    %trialList = str2num(TrialType(:,2));
    trialList = TrialType;
    cnt = 1;
    for i=1:6
        index = find( trialList == i);
        if numel(index) == 0
            continue;
        end
        diffIndex = diff(index);
        q = find(diffIndex~=1);

        if(isempty(q))
            trialIndex(cnt,:) = [i index(1) index(end)];
        else
            trialIndex(cnt,:) = [i index(1) index(q(1))];
            cnt = cnt + 1;
            v = size(q);
            for j = 1:v(2)-1
                trialIndex(cnt,:) = [i index(q(j)) index(q(j+1))];
                cnt = cnt + 1;
            end
            trialIndex(cnt,:) = [i index(q(end)+1) index(end)];
        end
        cnt = cnt + 1;
    end
end   
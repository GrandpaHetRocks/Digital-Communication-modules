function [encoded_data, final_codebook, long_bitstream] = encode(quantized, symbol, symbols_rowVector)

    %huffman

quant_size = size(quantized);
index_size = size(symbol);

index_unique = unique(symbol);
disp('Empirical Probability distribution of occurence of symbols coming out of the quantizer')
out = [index_unique',histc(symbol(:),index_unique')]./index_size
freq_symbols = out(:,2);
symbols = out(:,1);
symbols = string(symbols);
size(symbols);
for i = 1 : size(symbols,1)
    disp(symbols(i));
    if(symbols(i)=="0")
%         disp("KL");
        symbols(i)="A";
    end
    if(symbols(i)=="1")
        symbols(i)="B";
    end
    if(symbols(i)=="2")
%         disp("PP");
        symbols(i)="C";
    end
    if(symbols(i)=="3")
        symbols(i)="D";
    end
    if(symbols(i)=="4")
        symbols(i)="E";
    end
    if(symbols(i)=="5")
        symbols(i)="F";
    end
    if(symbols(i)=="6")
        symbols(i)="G";
    end
    if(symbols(i)=="7")
        symbols(i)="H";
    end
    if(symbols(i)=="8")
        symbols(i)="I";
    end
    if(symbols(i)=="9")
        symbols(i)="J";
    end
    if(symbols(i)=="10")
        symbols(i)="K";
    end
    if(symbols(i)=="11")
        symbols(i)="L";
    end
    if(symbols(i)=="12")
        symbols(i)="M";
    end
    if(symbols(i)=="13")
        symbols(i)="N";
    end
    if(symbols(i)=="14")
        symbols(i)="O";
    end
    if(symbols(i)=="15")
        symbols(i)="P";
    end
    if(symbols(i)=="16")
        symbols(i)="Q";
    end
    if(symbols(i)=="17")
        symbols(i)="R";
    end
    if(symbols(i)=="18")
        symbols(i)="S";
    end
    if(symbols(i)=="19")
        symbols(i)="T";
    end
    if(symbols(i)=="20")
        symbols(i)="U";
    end
    if(symbols(i)=="21")
        symbols(i)="V";
    end
    if(symbols(i)=="22")
        symbols(i)="W";
    end
    if(symbols(i)=="23")
        symbols(i)="X";
    end
    if(symbols(i)=="24")
        symbols(i)="Y";
    end
    if(symbols(i)=="25")
        symbols(i)="Z";
    end
    if(symbols(i)=="26")
        symbols(i)="a";
    end
    if(symbols(i)=="27")
        symbols(i)="b";
    end
    if(symbols(i)=="28")
        symbols(i)="c";
    end
    if(symbols(i)=="29")
        symbols(i)="d";
    end
    if(symbols(i)=="30")
        symbols(i)="e";
    end
    if(symbols(i)=="31")
        symbols(i)="f";
    end
end

prob_symbols = freq_symbols;
sort_symbols = symbols;
% Huffman encoding starts
initial_symbols = sort_symbols;
initial_prob = prob_symbols;
sorted_prob = prob_symbols;
i = 1;
while (length(sorted_prob) > 1)
    % Sort probs
    [sorted_prob,indices] = sort(sorted_prob,'ascend');

    % Sort string based on indeces
    sort_symbols = sort_symbols(indices);

    % Create new symbol & its prob
    new_symbol = strcat(sort_symbols(2),sort_symbols(1));
    new_prob = sum(sorted_prob(1:2));

    % Remove the 2 symbols from old array
    sort_symbols =  sort_symbols(3:length(sort_symbols));
    sorted_prob = sorted_prob(3:length(sorted_prob));

    % Add new symbol back to old array
    sort_symbols = [sort_symbols; new_symbol];
    sorted_prob = [sorted_prob; new_prob];

    % Add new symbol to new array
    new_symbols_arr(i) = new_symbol;
    new_prob_arr(i) = new_prob;

    i = i + 1;
end

% creating huffman tree
complete_tree = [new_symbols_arr,initial_symbols'];
complete_tree_prob = [new_prob_arr, initial_prob'];

% Sort all tree elements
[sorted_tree_prob,indices] = sort(complete_tree_prob,'descend');
sorted_complete_tree = complete_tree(indices);

% finding child-parent relationships by finding parent of each node
parent_arr(1) = 0; %depicting root node of the tree


for i = 2:length(sorted_complete_tree)
    % Extract a symbol
    symbol = sorted_complete_tree(i);
    % Finding parent symbol (shortest match)
    count = 1;
    parent = sorted_complete_tree(i-count);
    common = strfind(parent,symbol);
    while (isempty(common))
        count = count + 1;
        parent = sorted_complete_tree(i-count);
        common = strfind(parent,symbol);
    end
    parent_arr(i) = i - count;
end

figure(5);
treeplot(parent_arr);
title('Huffman Coding Tree');

% finding x,y coords of each node of the tree, ht of the tree & number of vertices s in the top-level separator.
[x_coords,y_coords,ht,s] = treelayout(parent_arr);

%assigning 0 and 1 wt to each edge of the tree via the concept of slope
for i = 2:length(sorted_complete_tree)

    % Get ith coord
    curr_x = x_coords(i);
    curr_y = y_coords(i);

    % parent of ith coord
    parent_curr_x = x_coords(parent_arr(i));
    parent_curr_y = y_coords(parent_arr(i));

    % mid pt of edge
    mid_x = (curr_x + parent_curr_x)/2;
    mid_y = (curr_y + parent_curr_y)/2;

    % weight of edge (for -ve slope = 1 and for +ve = 0)
    slope  = (parent_curr_y - curr_y)/(parent_curr_x - curr_x);
    if (slope > 0)
        weights_arr(i) = 0;
    else
        weights_arr(i) = 1;
    end
    text(mid_x,mid_y,num2str(weights_arr(i)));
end

% calculating the huffman code for each symbol in the huffman tree
for i = 1:length(sorted_complete_tree)

    final_symbol_code{i} = '';

    index = i;
    % find parent of the curr node
    parent_curr_node = parent_arr(index);
    % Loop until root node is found
    while(parent_curr_node ~= 0)

        % curr weight of the edge b/w child & parent
        curr_weight = num2str(weights_arr(index));

        % Concatenate the code symbols until we reach the root node
        final_symbol_code{i} = strcat(curr_weight,final_symbol_code{i});

        % find the parent of parent of the current node till we reach root node
        index = parent_arr(index);
        parent_curr_node = parent_arr(index);
    end
end


final_symbols = [];
final_codebook = [];
size(final_symbol_code);
for i = 1 : size(final_symbol_code,2)
    %disp(sorted_complete_tree(i));
    %disp(size(sorted_complete_tree(i),1));
    if(strlength(sorted_complete_tree(i))==1)
        final_symbols = [final_symbols ; sorted_complete_tree(i)];
        final_codebook = [final_codebook ; final_symbol_code(i)];
    end
end

% finding the final codebook for all the symbols of the huffman tree
code_book_symbols= [final_symbols, final_codebook];
disp('Codebook after Huffman Encoding');
code_book_symbols = sortrows(code_book_symbols)
final_codebook = code_book_symbols(:,2);
encoded_data ="";
final_codebook(1);
size(symbols_rowVector);
for i = 1 : size(symbols_rowVector,2)
    %disp(symbols_rowVector(i));
    if(symbols_rowVector(i)==0)
        s2 = final_codebook(1);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==1)
        s2 = final_codebook(2);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==2)
        s2 = final_codebook(3);
%         disp("PP");
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==3)
        s2 = final_codebook(4);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==4)
        s2 = final_codebook(5);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==5)
        s2 = final_codebook(6);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==6)
        s2 = final_codebook(7);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==7)
        s2 = final_codebook(8);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==8)
        s2 = final_codebook(9);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==9)
        s2 = final_codebook(10);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==10)
        s2 = final_codebook(11);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==11)
        s2 = final_codebook(12);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==12)
        s2 = final_codebook(13);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==13)
        s2 = final_codebook(14);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==14)
        s2 = final_codebook(15);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==15)
        s2 = final_codebook(16);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==16)
        s2 = final_codebook(17);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==17)
        s2 = final_codebook(18);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==18)
        s2 = final_codebook(19);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==19)
        s2 = final_codebook(20);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==20)
        s2 = final_codebook(21);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==21)
        s2 = final_codebook(22);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==22)
        s2 = final_codebook(23);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==23)
        s2 = final_codebook(24);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==24)
        s2 = final_codebook(25);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==25)
        s2 = final_codebook(26);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==26)
        s2 = final_codebook(27);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==27)
        s2 = final_codebook(28);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==28)
        s2 = final_codebook(29);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==29)
        s2 = final_codebook(30);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==30)
        s2 = final_codebook(31);
        encoded_data = strcat(encoded_data,s2);
    end
    if(symbols_rowVector(i)==31)
        s2 = final_codebook(32);
        encoded_data = strcat(encoded_data,s2);
    end
end
encoded_data=char(encoded_data);
Output=char(num2cell(encoded_data));
Output=reshape(str2num(Output),1,[]);
encoded_data=Output;
long_bitstream=encoded_data;
disp('Bitstream size after Huffman encoding =')
disp(size(long_bitstream,2));
end
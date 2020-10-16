 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                FONCTION DE DECOMPRESSION SELON HUFFMAN                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Cette fonction suit l'algorithme de Huffman
% pour décompresser un message codé
% 

function dec = huffman_decompr(zip,code)

zip = char(zip)+48;

% Recherche du mot de code
dec = '';
i = 1;
while (i <= length(zip))
    for j = 1 : length(code)
       mot_code = code(j).valeur;
       if ((i+length(mot_code)-1)<=length(zip))
            mot_zip = zip(i:i+length(mot_code)-1);
            OK = (mot_zip == mot_code);
            if (OK)
                mot_dezip = code(j).info;
                longueur = length(mot_code);
            end
        end
    end
    dec = [dec, mot_dezip];
    i = i + longueur;
end

% Transformation en caractère
dec = char(dec);

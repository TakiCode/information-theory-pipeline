%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                     %%
%%              FONCTION DE CRYPTAGE DE VIGENERE                       %%
%%                                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function chiffre=cryptage(texte_clair, cle)

% Création de la table de Vigenère
table = ones(26,1)*[1:26];
tableT = table';
Vigenere = mod(table + tableT-2,26) + 1;

% Conversion du texte en clair en une suite de nombre entre 1 et 26
texte_nombre=char2int(texte_clair);

% Conversion de la clé en une suite de nombre entre 1 et 26
cle_nombre=char2int(cle);

% Création de la clé
for j = 1 : floor(length(texte_nombre)/length(cle_nombre)) + 1
    for i = 1 : length(cle_nombre)
        if (i + (j-1)*length(cle_nombre)) <= length(texte_nombre)
            cle_nombre_Vig(i + (j-1)*length(cle_nombre)) = cle_nombre(i);
        end
    end
end
% Lecture dans la table de Vigenère
for i = 1 : length(texte_nombre)
    chiffre_nombre(i) = Vigenere(cle_nombre_Vig(i),texte_nombre(i));
end
chiffre = char(chiffre_nombre + 64);


% --------
function entier = char2int(texte)
texte_nombre=uint8(texte);
for i = 1 : length(texte_nombre)
    % Convertit le point en 27
    if texte_nombre(i) == 46
        texte_nombre(i) = 27 + 64;
    elseif texte_nombre(i) == 32
        % Convertit l'espace en 28
        texte_nombre(i) = 28 + 64;
    elseif texte_nombre(i) == 44
        % Convertit la virgule en 29
        texte_nombre(i) = 29 + 64;
    end
end
entier=texte_nombre - 64;
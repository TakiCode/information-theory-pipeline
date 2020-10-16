%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                     %%
%%                   FONCTION DE DECRYPTAGE                            %%
%%                                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function texte = decryptage(chiffre, cle)

% Création de la table de Vigenère
table = ones(26,1)*[1:26];
tableT = table';
Vigenere = mod(table + tableT-2,26) + 1;

% Conversion du cryptogramme en une suite de nombre entre 1 et 26
chiffre_nombre=char2int(chiffre);

% Conversion de la clé en une suite de nombre entre 1 et 26
cle_nombre=char2int(cle);

% Création de la clé
for j = 1 : floor(length(chiffre_nombre)/length(cle_nombre)) + 1
    for i = 1 : length(cle_nombre)
        if (i + (j-1)*length(cle_nombre)) <= length(chiffre_nombre)
            cle_nombre_Vig(i + (j-1)*length(cle_nombre)) = cle_nombre(i);
        end
    end
end
% Déchiffrement
for i = 1 : length(chiffre_nombre)
    ligne = Vigenere(cle_nombre_Vig(i),:);
    ligne = (ligne == chiffre_nombre(i));
    indice = find(ligne);
    texte_nombre(i) = Vigenere(1,indice);
end
texte = int2char(texte_nombre);


% -----------
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

% -----------
function texte = int2char(nombre)
for i = 1 : length(nombre)
    % Convertit le 27 en point
    if nombre(i) == 27
        nombre(i) = 46 - 64;
    elseif nombre(i) == 28
        % Convertit 28 en espace
        nombre(i) = 32 - 64;
    elseif nombre(i) == 29
        % Convertit la virgule en 29
        nombre(i) = 44 - 64;

    end
end
texte = char(nombre + 64);
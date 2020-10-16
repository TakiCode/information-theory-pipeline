%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                     %%
%%        FONCTION DE CONVERSION D'UN TEXTE EN ENTIERS                 %%
%%                                                                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
# OkiDokiLand

*OkiDokiLand* è un progetto volto alla rappresentazione di *lands* e *assets* (al momento solo *buildings*) mediante *smart contracts* scritti in linguaggio *Solidity*.

Lo scopo del progetto è, come specificato dal *project work* di NTT Data per MasterZ, rendere possibile l'acquisto e la vendita di tali *asset* digitali su rete Ethereum.

> N.B.: per brevità i dettagli circa il project work non sono disponibili in questa pagina.

> N.B.(2): Per differenze tra ERC721 e ERC1155 clicca [qui](#differenze-tra-ERC721-e-ERC1155).

## Tecnologie utilizzate

Gli *smart contracts* sono stati scritti e pensati secondo i seguenti accorgimenti:
1. versione del compilatore di Solidity: **0.8.3**;
2. utilizzo delle librerie *OpenZeppelin* `ERC721Upgradeable` e `ERC1155Upgradeable`;
3. il deploy su rete di test *Ropsten* è stato effettuato mediante Node.js, in particolare Hardhat;
4. per l'interazione con il contratto si fa uso di *Alchemy Web3*;
5. per l'upload dei metadati si è scelto *Pinata*, bridge di IPFS.

## Let's go!

Per eseguire il deploy in autonomia, come anticipato nei punti (3) e (4):
- installare Node.js + npm;
- installare Alchemy: `npm install --save-dev @alch/alchemy-web3`;
- installare HardHat: `npm install --save-dev hardhat`;

## Differenze tra ERC721 e ERC1155 

Il primo dei due, l'ERC721, il più diffuso e primo tra i due ad essere ideato, è lo standard per la rappresentazione di un *Non-Fungible Token*.
Di fatto, il token rappresentato dall'ERC721 è immutable, trasparente, *ownable* e sicuro, tutte caratteristiche che rendono
il token **non fungibile**.
Inoltre è indivisibile e trasferibile, il che gli conferisce un valore a seconda del mercato e altri fattori.
</br>

Purtroppo, però, l'altro lato della medaglia espone i seguenti lati negativi:
- *gas fee* richieste decisamente alte per la sua creazione (*minting*);
- trasferire intere collezioni diventa complicato;
- impossibile annullare un pagamento;
- impossibile combinare più token per ottenerne uno completamente nuovo (e.g.: terre e costruzioni).
</br>

Lo standard ERC1155 risolve questi problemi poichè **è un token che può rappresentare più token** (fungibili e non).
Per effettuare un paragone: se una land è rappresentata dall'ERC721, l'intero gioco/mondo può essere rappresentato dall'ERC1155, e al suo interno vi saranno funzioni e metodi per effettuare il minting di più terre e costruzioni.
Quindi l'ERC1155 è un singolo contratto capace di effettuare un *multi-token minting*.
Inoltre diventa possibile annullare un pagamento, le *gas fee* sono inferiori del 90% (rendendo possibile ai più l'acquisto di un sottotipo di *token*) e acquistare più tipi di token in una sola chiamata.

Di contro, diventa più complesso gestire la proprietà di un token. La specifica dell'ERC1155 non è ancora così
robusta sotto quest'aspetto, contrariamente all'ERC721.
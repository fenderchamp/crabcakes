/**
 * A game of Crabcakes Allison's Friend's Cousin's game
 */
function CrabCakes(args) {

    var number_of_players=args.number_of_players;  

    this.board = new Board({
        rootId : "DivCrabCakes",
        magicalX : 80,
        magicalY : 110
    });


    this.drawPlayer=function(args)  {

        var player =args.player;
        var position = args.position;

        var board=this.board;

        var crabCakesRow = 1; 
        var handRow = 0; 
        var ccStart;
        if ( position === 'south' ) { 
           crabCakesRow = 3; 
           handRow = 4; 
        }
        
        var board=this.board;
        var hand = new Deck(board.horizontalType, 2, handRow);
        var crabCakes=[];

    	for (i = 0; i < 4; i++) {
            crabCakes[i] = new Deck(board.collapsedType, (i+1) , crabCakesRow);
            board.addDeck(crabCakes[i]);
         }
         board.addDeck(hand);
    };


    if ( number_of_players === 2 ) {

       this.drawPlayer({
			 player:0,
			 position:'south'
       });
       this.drawPlayer({
			player:1,
			position:'north'
       });
     } else if ( number_of_players === 3 ) {
       this.drawPlayer({
			 player:0,
			 position:'south'
       });
       this.drawPlayer({
			 player:1,
 			 position:'west'
       });
       this.drawPlayer({
			 player:2,
 			 position:'east'
       });
    }

    var deck = new Deck(this.board.collapsedType, 1, 2);
    var pile = new Deck(this.board.collapsedType, 2, 2);
    var discards = new Deck(this.board.collapsedType, 4, 2);
    this.board.addDeck(deck);
    this.board.addDeck(pile);
    this.board.addDeck(discards);


}


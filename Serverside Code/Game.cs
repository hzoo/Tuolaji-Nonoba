using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Text;
using System.Threading;
using Nonoba.GameLibrary;

namespace ServersideGameCode {
    public class Player : NonobaGameUser
    {
        public int playerNum = -1;
        public Boolean isReady = true;
        public int rank = 2; // we'll add one every time
        public String playerName;
        public int numPoints = 0;
        
        public Boolean isPlayerReady() { return isReady; }
        public void setReady(Boolean b) { isReady = b; }
        public String getPlayerName() { return playerName; }
        public void setPlayerName(String s) { playerName = s; }
        public int getPlayerNum() { return playerNum; }
        public void setPlayerNum(int s) { playerNum = s; }
		public int getPlayerRank() { return rank; }
        public void setPlayerRank(int s) { rank = s; }
        public int getPoints() { return numPoints; }
        public void setgetPoints(int s) { numPoints = s; }
    }

    public class Card : NonobaGameUser, IComparable
    {
        public int value;
        public int suit;
        public Tuolaji t;

        public Card(int v, int s, Tuolaji t)
        {
            value = v;
            suit = s;
            this.t = t;
        }

        public int getCompareValue()
        {
            if (value == t.getCurrentLevel() && suit != t.getCurrentSuit())
            {
                return CardValue.CURRENTLEVEL;
            }
            else if (value == t.getCurrentLevel() && suit == t.getCurrentSuit())
            {
                return CardValue.CURRENTLEVELSUIT;
            }
            else
            {
                return value;
            }
        } 

        public int getValue() { return value; }
        public void setValue(int s) { value = s; }
        public int getSuit() { return suit; }
        public void setSuit(int s) { suit = s; }
		
		//3 different equals methods
        public override bool Equals(System.Object obj)
        {
            // If parameter is null return false.
            if (obj == null)
            {
                return false;
            }

            // If parameter cannot be cast to Point return false.
            Card c = obj as Card;
            if ((System.Object)c == null)
            {
                return false;
            }

            // Return true if the fields match:
            return (value == c.value) && (suit == c.suit);
        }
		
        public bool Equals(Card c)
        {
            // If parameter is null return false:
            if ((object)c == null)
            {
                return false;
            }

            // Return true if the fields match:
            return (value == c.value) && (suit == c.suit);
        }
		
        public override int GetHashCode()
        {
            return value ^ suit;
        }
		
		//long compareto method..
		//check joker red, joker black, curr level, curr suit, suit, value
        public int CompareTo(Object o)
        {
            Card c = (Card)o;
            if (this.value == CardValue.JOKERRED && c.value != CardValue.JOKERRED)
                return 1;
            else if (this.value != CardValue.JOKERRED && c.value == CardValue.JOKERRED)
                return -1;
            else
            {
                if (this.value == CardValue.JOKERBLACK && c.value != CardValue.JOKERBLACK)
                    return 1;
                else if (this.value != CardValue.JOKERBLACK && c.value == CardValue.JOKERBLACK)
                    return -1;
                else
                {
                    if (this.value == t.getCurrentLevel() && c.value != t.getCurrentLevel())
                        return 1;
                    else if (this.value != t.getCurrentLevel() && c.value == t.getCurrentLevel())
                        return -1;
                    else
                    {
                        if (this.suit == t.getCurrentSuit() && c.suit != t.getCurrentSuit())
                            return 1;
                        else if (this.suit != t.getCurrentSuit() && c.suit == t.getCurrentSuit())
                            return -1;
                        else
                        {
                            if (this.suit == t.getFirstTurnSuit() && c.suit != t.getFirstTurnSuit())
                                return 1;
                            else if (this.suit != t.getFirstTurnSuit() && c.suit == t.getFirstTurnSuit())
                                return -1;
                            else
                            {
                                if (this.value > c.value)
                                    return 1;
                                else if (this.value < c.value)
                                    return -1;
                                else
                                    return 0;
                            }
                        }
                    }
                }
            }
        }
    }

    public class CardValue : NonobaGameUser
    {
		//const auto static
        public const int TWO = 2;
        public const int THREE = 3;
        public const int FOUR = 4;
        public const int FIVE = 5;
        public const int SIX = 6;
        public const int SEVEN = 7;
        public const int EIGHT = 8;
        public const int NINE = 9;
        public const int TEN = 10;
        public const int JACK = 11;
        public const int QUEEN = 12;
        public const int KING = 13;
        public const int ACE = 14;
        //public const int JOKER = 15;
        public const int CURRENTLEVEL = 15;
        public const int CURRENTLEVELSUIT = 16;
        public const int JOKERBLACK = 17;
        public const int JOKERRED = 18;
    }

    public class Suit : NonobaGameUser
    {
        public const int DIAMONDS = 0;
        public const int CLUBS = 1;
        public const int HEARTS = 2;
        public const int SPADES = 3;
        //public const int BLACK = 4;
        //public const int RED = 5;
        public const int JOKER = 4;
    }

    public class ShuaiPart : NonobaGameUser, IComparable
    {
        private Card startCard;
        private int numSame;
        private int numConsecutive;

        public ShuaiPart(Card s, int s2, int s3)
        {
            startCard = s;
            numSame = s2;
            numConsecutive = s3;
        }

        public int CompareTo(object o)
        {
            ShuaiPart s = (ShuaiPart)o;
            if (numSame*numConsecutive > s.numSame*s.numConsecutive)
            {
                return 1;
            }
            else
            {
                return startCard.CompareTo(s.getStartCard());
            }
        }

        public Card getStartCard() { return startCard; }
        public int getNumSame() { return numSame; }
        public int getNumConsecutive() { return numConsecutive; }
        public override String ToString() { return (startCard.getValue() + " " + numSame + " " + numConsecutive); }
    }

    public class Tuolaji : NonobaGameUser
    {
        private List<Card> cards; //total cards from decks
		private List<Card> bottomPile;
        private ArrayList playerPiles; //each person's hand
        private ArrayList handPiles; //what each person played
		private ArrayList handPilesOrganized; //into parts
        private ArrayList handPilesShaui;
        private List<Card> illegitPart;
        private int[] points; //num pts earned for each person 
		
        private int numPiles;// = 4;
        private int numDecks;// = 2;
		private int numCards;
        private int numCardsBottom;// = 8;
		private int numCardsToDeal;
        
        public int currentLevel;// = 2;//master level
        public int currentSuit;//trump suit
        private int numCardsChangeSuit;
		
        private int hasTurn = -1; //current turn
        private int master = -1;
        private int firstTurn = -1;
		
		private int numPts = 0; //numpts for attacking team
        private int pointsToAdd = 0; //pts to add to team if win
        private int firstTurnSuit = 0;

        private Card startCardBeatShuai;

        public Tuolaji(int numPpl, int numD)
        {
			//default - need a setting to change?
            numPiles = numPpl;
            numDecks = numD;
			numCards = 54 * numDecks;
			numCardsBottom = (54*numDecks)%numPiles;
            numCardsToDeal = numCards - numCardsBottom;
            while (numCardsBottom <= 4)
            {
                numCardsBottom += numPiles;
                numCardsToDeal -= numPiles;
            }
			
			currentLevel = 2;//master level
        }

        public void reset()
        {
            //currentRank = 2;
            //master = -1;
            currentSuit = 0;//trump suit
            numCardsChangeSuit = 0;
            //hasTurn = -1;
            numPts = 0;
            pointsToAdd = 0;
            //firstTurn = -1;
            firstTurnSuit = 0;

            cards = createDeck(numCards);
            playerPiles = new ArrayList();
            handPiles = new ArrayList();
            handPilesOrganized = new ArrayList();
            handPilesShaui = new ArrayList();
            points = new int[numPiles];
            for (int i = 0; i < numPiles; i++)
            {
                playerPiles.Add(new List<Card>());
                handPiles.Add(new List<Card>());
                handPilesOrganized.Add(new ArrayList());
                handPilesShaui.Add(new ArrayList());
                points[i] = 0;
            }
            bottomPile = new List<Card>();
        }
		
		//shuai
		//n-tuples (single, pair, triple...)
		//consecutive n-tuples
		
		public Boolean isTrump(Card c)
		{
            if (c.value == CardValue.JOKERBLACK || c.value == CardValue.JOKERRED || c.value == currentLevel || c.suit == currentSuit)
				return true;
			else
				return false;
		}
		
		public void sendCardsOrganize(int pNum)
		{
            List<Card> pile = (List<Card>)(handPiles[pNum]);
            firstTurnSuit = pile[0].getSuit();
			Card temp = null;
			int part = 0;
            ArrayList org = ((ArrayList)(handPilesOrganized[pNum]));
			//organize n-tuples into parts
            for (int i = 0; i < pile.Count; i++)
			{
				Card c = pile[i];
                List<Card> newPart;
				if (org.Count == 0)
				{
                    org.Add(new List<Card>());
                    newPart = ((List<Card>)(org[part]));
                    newPart.Add(c);
					temp = c;
				}
				else
				{
					if (temp.Equals(c))
					{
                        newPart = ((List<Card>)(org[part]));
                        newPart.Add(c);
					}
					else
					{
                        org.Add(new List<Card>());
						part = part + 1;
                        newPart = ((List<Card>)(org[part]));
                        newPart.Add(c);
						temp = c;
					}
				}
			}
            //combine any n-tuples into tuolajis

            for (int j = 0; j < org.Count-1; j++)
            {
                List<Card> tuple1 = ((List<Card>)(org[j]));
                List<Card> tuple2 = ((List<Card>)(org[j + 1]));

                Boolean b = (tuple1.Count == tuple2.Count && tuple2.Count > 1);
                int toAdd = 1;
                if (b && ((Card)(tuple1[0])).getCompareValue() == ((Card)(tuple2[0])).getCompareValue() + toAdd)
                {
                    for (int k = 0; k < tuple2.Count; k++)
                    {
                        tuple1.Add(tuple2[k]);
                    }
                    org.RemoveAt(j + 1);
                    j--;
                    toAdd++;
                }
                else if (b && ((Card)(tuple1[0])).getCompareValue() == (currentLevel + toAdd) && ((Card)(tuple2[0])).getCompareValue() == (currentLevel - 1))
                {
                    for (int k = 0; k < tuple2.Count; k++)
                    {
                        tuple1.Add(tuple2[k]);
                    }
                    org.RemoveAt(j + 1);
                    j--;
                    toAdd += 2;
                }
                else if (b && ((Card)(tuple1[0])).getCompareValue() == (currentLevel + 1) && ((Card)(tuple2[0])).getCompareValue() == (currentLevel - toAdd))
                {
                    for (int k = 0; k < tuple2.Count; k++)
                    {
                        tuple1.Add(tuple2[k]);
                    }
                    org.RemoveAt(j + 1);
                    j--;
                    toAdd++;
                }
                else
                {
                    toAdd = 1;
                }
            }

            ArrayList test = ((ArrayList)(handPilesShaui[pNum]));

            for (int j = 0; j < org.Count; j++)
            {
                List<Card> tuple1 = ((List<Card>)(org[j]));
                Card startValue = ((Card)(tuple1[0]));//.getValue();
                int numSame = 1;
                int numConsecutive = 1;

                for (int k = 0; k < tuple1.Count-1; k++)
                {
                    if (tuple1[k].Equals(tuple1[k + 1]))
                    {
                        numSame++;
                    }
                    else
                    {
                        break;
                    }
                }

                for (int k = 0; k < tuple1.Count - 1; k++)
                {
                    if (!tuple1[k].Equals(tuple1[k + 1]))
                    {
                        numConsecutive++;
                    }
                }

                test.Add(new ShuaiPart(startValue, numSame, numConsecutive));
            }
		}
		
		public Boolean checkLegit(int pNum)
		{
            ArrayList org = ((ArrayList)(handPilesOrganized[pNum]));
            if (pNum != firstTurn)
            {
				//make sure one plays the same number of cards as firstTurn
                if (((List<Card>)(handPiles[pNum])).Count != ((List<Card>)(handPiles[firstTurn])).Count)
                    return false;
                else
                {
                    //match firstTurn
                    if (((ArrayList)(handPilesOrganized[firstTurn])).Count != 1)
                    {

                    }
                }
            }
            else
            {
                if (org.Count != 1)
                {
                    return checkShuai();
                }
                else
                {
                    return true;
                }
            }
			return true;
		}

        public void sortShuai(ArrayList o)
        {
            o.Sort();
            o.Reverse();
        }

        public Boolean checkShuai()
        {
            ArrayList org = ((ArrayList)(handPilesShaui[firstTurn]));
            int maxSize = firstTurn;

            sortShuai(((ArrayList)(handPilesShaui[firstTurn])));
            for (int i = 0; i < org.Count; i++)
            {
                ShuaiPart part = ((ShuaiPart)(org[i]));
                if (checkHighestPart(part) == false)
                {
                    illegitPart = (List<Card>)((ArrayList)(handPilesOrganized[firstTurn]))[i];
                    for (int j = i; j < org.Count; j++)
                    {
                        ShuaiPart temp = ((ShuaiPart)(org[j]));
                        if (j != i && part.getNumSame() == temp.getNumSame() && part.getNumConsecutive() == temp.getNumConsecutive() && temp.getStartCard().CompareTo(part.getStartCard()) < 0)
                        {
                            illegitPart = (List<Card>)((ArrayList)(handPilesOrganized[firstTurn]))[j];
                        }
                    }
                    return false;
                }
            }
            
            return true;
        }

        public Boolean checkHighestPart(ShuaiPart p)
        {
            int suit = p.getStartCard().getSuit();
            for (int i = 0; i < playerPiles.Count; i++)
            {
                if (i != firstTurn)
                {
                    List<Card> pp = (List<Card>)playerPiles[i];

                    for (int j = 0; j < pp.Count-1; j++)
                    {
                        Card c = pp[j];
                        int numSame = 1;
                        int numConsecutive = 1;
                        Card same = c;
                        Card con = null;

                        if (c.getSuit() == suit && !isTrump(p.getStartCard()) && c.getCompareValue() <= CardValue.ACE || isTrump(c) && isTrump(p.getStartCard()))
                        {
                            for (int k = j+1; k < pp.Count; k++)
                            {
                                Card c2 = pp[k];
                                if (c2.getSuit() == suit && !isTrump(p.getStartCard()) && c2.getCompareValue() <= CardValue.ACE || isTrump(c2) && isTrump(p.getStartCard()))
                                {
                                    if (numSame < p.getNumSame())
                                    {
                                        if (c2.Equals(same))
                                        {
                                            numSame++;
                                        }
                                    }
                                    else
                                    {
                                        con = new Card(same.getCompareValue() - 1, same.getSuit(), this);
                                        if (numConsecutive < p.getNumConsecutive())
                                        {
                                            if (c2.Equals(con))
                                            {
                                                numConsecutive++;
                                                same = con;
                                                numSame = 1;
                                            }
                                        }
                                        else
                                        {
                                            Boolean b = (c.CompareTo(p.getStartCard()) > 0);
                                            int a = c.CompareTo(p.getStartCard());
                                            if (c.CompareTo(p.getStartCard()) > 0)
                                            {
                                                startCardBeatShuai = c;
                                                return false;
                                            }
                                        }
                                    }
                                }        
                            }
                        }
                    }
                }
            }
            return true;
        }

        public int highestHand()
        {
            ArrayList org = ((ArrayList)(handPilesShaui[firstTurn]));

            int maxSize = firstTurn;
            for (int i = 0; i < handPilesShaui.Count; i++)
            {
                ArrayList newHand = ((ArrayList)(handPilesShaui[i]));
                ArrayList maxHand = ((ArrayList)(handPilesShaui[maxSize]));
                if (newHand.Count == 1)
                {
                    ShuaiPart newS = (((ShuaiPart)(newHand[0])));
                    ShuaiPart maxS = (((ShuaiPart)(maxHand[0])));
                    if (newS.getNumSame() == maxS.getNumSame() && newS.getNumConsecutive() == maxS.getNumConsecutive())
                    {
                        if (newS.getStartCard().CompareTo(maxS.getStartCard()) > 0)
                        {
                            maxSize = i;
                        }
                    }
                }
            }
            return maxSize;
        }

        public int highestShuai()
        {
            ArrayList org = ((ArrayList)(handPilesShaui[firstTurn]));
            Boolean b = false;
            int maxSize = firstTurn;
            for (int i = 0; i < handPilesShaui.Count; i++)
            {
                ArrayList newHand = ((ArrayList)(handPilesShaui[i]));
                ArrayList maxHand = ((ArrayList)(handPilesShaui[maxSize]));
                sortShuai(newHand);
                if (newHand.Count == maxHand.Count && i != maxSize)
                {
                    for (int j = 0; j < newHand.Count; j++)
                    {
                        ShuaiPart newS = (((ShuaiPart)(newHand[j])));
                        ShuaiPart maxS = (((ShuaiPart)(maxHand[j])));
                        if (newS.getNumSame() == maxS.getNumSame() && newS.getNumConsecutive() == maxS.getNumConsecutive())
                        {
                            if (newS.getStartCard().CompareTo(maxS.getStartCard()) > 0)
                            {
                                b = true;
                            }
                            else
                            {
                                b = false;
                                break;
                            }
                        }
                    }
                }
                if (b)
                {
                    maxSize = i;
                    b = false;
                }
            }
            return maxSize;
        }

		//very long method - need to change/generalize 
        public int checkPoints(ArrayList p) 
        {
            //ace == 14
            if (master % 2 == 0)
            {
                if (numPts < 40 * numDecks)
			    {
				    if (numPts == 0)//att +3
				    {
                        for (int i = 0; i < numPiles; i += 2)
					        ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank()+3);
				    }
				    else if (numPts > 0 && numPts < 20 * numDecks)//att +2
				    {
					    for (int i = 0; i < numPiles; i += 2)
					        ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank()+2);
				    }
				    else if (numPts >= 20 * numDecks && numPts < 40 * numDecks)//att +1
				    {
					    for (int i = 0; i < numPiles; i += 2)
					        ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank()+1);
				    }

                    if (master < numPiles-2)
                        master = master + 2;
                    else
                        master = 0;
			    }
                else if (numPts >= 40 * numDecks)//0
			    {
				    if (numPts >= 60 * numDecks && numPts < 80 * numDecks)//def +1
				    {
					    for (int i = 1; i < numPiles; i += 2)
					        ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank()+1);
				    }
				    else if (numPts >= 80 * numDecks && numPts < 100 * numDecks)//def +2
				    {
					    for (int i = 1; i < numPiles; i += 2)
					        ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank()+2);
				    }
				    else if (numPts >= 100*numDecks)//def +3
				    {
					    for (int i = 1; i < numPiles; i += 2)
					        ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank()+3);
				    }

                    master = master + 1;
			    }
            }
            else
            {
                if (numPts < 40 * numDecks)
                {
                    if (numPts == 0)//att +3
                    {
                        for (int i = 1; i < numPiles; i += 2)
                            ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank() + 3);
                    }
                    else if (numPts > 0 && numPts < 20 * numDecks)//att +2
                    {
                        for (int i = 1; i < numPiles; i += 2)
                            ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank() + 2);
                    }
                    else if (numPts >= 20 * numDecks && numPts < 40 * numDecks)//att +1
                    {
                        for (int i = 1; i < numPiles; i += 2)
                            ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank() + 1);
                    }

                    if (master < numPiles - 1)
                        master = master + 2;
                    else
                        master = 1;
                }
                else if (numPts >= 40 * numDecks)//0
                {
                    if (numPts >= 60 * numDecks && numPts < 80 * numDecks)//def +1
                    {
                        for (int i = 0; i < numPiles; i += 2)
                            ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank() + 1);
                    }
                    else if (numPts >= 80 * numDecks && numPts < 100 * numDecks)//def +2
                    {
                        for (int i = 0; i < numPiles; i += 2)
                            ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank() + 2);
                    }
                    else if (numPts >= 100 * numDecks)//def +3
                    {
                        for (int i = 0; i < numPiles; i += 2)
                            ((Player)(p[i])).setPlayerRank(((Player)(p[i])).getPlayerRank() + 3);
                    }

                    if (master < numPiles - 1)
                        master = master + 1;
                    else
                        master = 0;
                }
            }

            /*Player p1;
            Player p2;
            Player p3;
            Player p4;
            if (master == 0 || master == 2)
            {
				p1 = (Player)(p[0]);
				p2 = (Player)(p[2]);
				p3 = (Player)(p[1]);
				p4 = (Player)(p[3]);
			}
            else
			{
                p1 = (Player)(p[1]);
				p2 = (Player)(p[3]);
				p3 = (Player)(p[0]);
				p4 = (Player)(p[2]);
			}

			if (numPts < 40 * numDecks)
			{
				if (numPts == 0)//att +3
				{
					p1.setPlayerRank(p1.getPlayerRank()+3);
					p2.setPlayerRank(p2.getPlayerRank()+3);
				}
				else if (numPts > 0 && numPts < 20 * numDecks)//att +2
				{
					p1.setPlayerRank(p1.getPlayerRank()+2);
					p2.setPlayerRank(p2.getPlayerRank()+2);
				}
				else if (numPts >= 20 * numDecks && numPts < 40 * numDecks)//att +1
				{
					p1.setPlayerRank(p1.getPlayerRank()+1);
					p2.setPlayerRank(p2.getPlayerRank()+1);
				}

                if (master == p1.getPlayerNum())
                {
                    master = p2.getPlayerNum();
                }
                else
                {
                    master = p1.getPlayerNum();
                }
			}
            else if (numPts >= 40 * numDecks)//0
			{
				if (numPts >= 60 * numDecks && numPts < 80 * numDecks)//def +1
				{
					p3.setPlayerRank(p3.getPlayerRank()+1);
					p4.setPlayerRank(p4.getPlayerRank()+1);
				}
				else if (numPts >= 80 * numDecks && numPts < 100 * numDecks)//def +2
				{
					p3.setPlayerRank(p3.getPlayerRank()+2);
					p4.setPlayerRank(p4.getPlayerRank()+2);
				}
				else if (numPts >= 100*numDecks)//def +3
				{
					p3.setPlayerRank(p3.getPlayerRank()+3);
                    p4.setPlayerRank(p4.getPlayerRank() + 3);
				}

                if (master == p3.getPlayerNum())
                {
                    master = p4.getPlayerNum();
                }
                else
                {
                    master = p3.getPlayerNum();
                }
			}
            */

            //who is master
            currentLevel = ((Player)(p[master])).getPlayerRank();
            hasTurn = master;
            firstTurn = master;

            ArrayList lp = new ArrayList();
            for (int i = 0; i < p.Count; i++)
            {
                lp.Add(((Player)(p[i])).getPlayerRank());
            }

            for (int i = 0; i < p.Count; i++)
            {
                if ((int)(lp[i]) > 14)
                {
                    return (int)(lp[i]);
                }
            }
            return -1;
        }

        public void changeSuit(int suit, int numC)
        {
            currentSuit = suit;
			//black and red jokers.. but joker suit is just 4 so change 5 to 4
            if (suit == 5)
                currentSuit = 4;
            numCardsChangeSuit = numC;
        }

        public int nextTurn()
        {
            if (hasTurn < numPiles-1)
                hasTurn = hasTurn + 1;
            else
                hasTurn = 0;
            return hasTurn;
        }
		
		//only evaluates for 1,2,4 cards - otherwise player 0 wins
        public int evalHands()
        {
            int numPlayer = 0;
            if (((ArrayList)(handPilesOrganized[firstTurn])).Count == 1)
            {
                numPlayer = highestHand();
            }
            else
            {
                numPlayer = highestShuai();
            }
            for (int i = 0; i < numPiles; i++)
            {
                handPiles[i] = new List<Card>();
                handPilesOrganized[i] = new ArrayList();
                handPilesShaui[i] = new ArrayList();
            }
            //addPointsToPlayer
            points[numPlayer] = ((int)(points[numPlayer])) + pointsToAdd;
			pointsToAdd = 0;
            setTurn(numPlayer);
            hasTurn = numPlayer;
			firstTurn = numPlayer;
            return numPlayer;
        }

        //only for even num players
        public int getCurrentPoints()
        {
            int temp = 0;

            if (master % 2 == 0)
            {
                for (int i = 1; i < numPiles; i+=2)
                    temp += points[i];
            }
            else
            {
                for (int i = 0; i < numPiles; i += 2)
                    temp += points[i];
            }
            numPts = temp;
            return numPts;
        }

        /*public int playedFirst(int p1, int p2)
        {
            int turn;
			turn = firstTurn;
			
            if (p1 == turn)
                return p1;
            else if (p2 == turn)
                return p2;
            else
            {
                if (p1 > turn && p2 > turn || p1 < turn && p2 < turn)
                {
                    if (p1 < p2)
                        return p1;
                    else
                        return p2;
                }
                else
                {
                    if (p1 > turn && p2 < turn)
                        return p1;
                    else
                        return p2;
                }
            }
        }*/

        public int giveBottomPoints()
        {
            int ptsAdd = 0;
            for (int i = 0; i < bottomPile.Count; i++)
            {
                Card c = ((Card)(bottomPile[i]));
                if (c.getValue() == CardValue.FIVE)
                    ptsAdd += 10;
                else if (c.getValue() == CardValue.TEN)
                    ptsAdd += 20;
                else if (c.getValue() == CardValue.KING)
                    ptsAdd += 20;
            }
            numPts = numPts + ptsAdd;
            return ptsAdd;
        }

        public void addPoints(Card c)
        {
            if (c.getValue() == CardValue.FIVE)
                pointsToAdd += 5;
            else if (c.getValue() == CardValue.TEN)
                pointsToAdd += 10;
            else if (c.getValue() == CardValue.KING)
                pointsToAdd += 10;
        }

        public List<Card> getCards() { return cards; }
        public int getNumPiles() { return numPiles; }
        public int getNumDecks() { return numDecks; }
        public int getNumCardsBottom() { return numCardsBottom; }
        public int getCurrentLevel() { return currentLevel; }
        public void setCurrentLevel(int c) { currentLevel = c; }
        public int getCurrentSuit() { return currentSuit; }
        public List<Card> getPlayerPiles(int num) { return ((List<Card>)(playerPiles[num])); }
        public List<Card> getHandPiles(int num) { return ((List<Card>)(handPiles[num])); }
        public List<Card> getBottomPile() { return bottomPile; }
        public int getTurn() { return hasTurn; }
        public void resetBottomPile() { bottomPile = new List<Card>(); }
        public void resetPlayerPile(int num) { playerPiles[num] = new List<Card>(); }
        public void resetHandPile(int num) { handPiles[num] = new List<Card>(); }
        public void resetHandOrganizedPile(int num) { handPilesOrganized[num] = new ArrayList(); }
        public void resetHandShuaiPile(int num) { handPilesShaui[num] = new ArrayList(); }
        public int getCurrentMaster() { return master; }
        public void setMaster(int m) { master = m; }
        public void setTurn(int s) { hasTurn = s; }
        public void setFirstTurn(int s) { firstTurn = s; }
        public int getFirstTurn() { return firstTurn; }
        public int getNumPts() { return numPts; } //only call at end
        public ArrayList getHandPilesOrganized(int pNum) { return ((ArrayList)(handPilesOrganized[pNum])); }
        public ArrayList getHandPilesShaui(int pNum) { return ((ArrayList)(handPilesShaui[pNum])); }
        public List<Card> getIllegitPart() { return illegitPart; }
        public int getFirstTurnSuit() { return firstTurnSuit; }

        public void deal()
        {
            int i = 0;
            while (i < numCardsToDeal)
            {
                for (int j = 0; j < numPiles; j++)
                { 
                    Card card2 = ((Card)cards[i]);
                    ((List<Card>)(playerPiles.GetRange(j, 1)[0])).Add(new Card(card2.getValue(),card2.getSuit(),this));//card2
                    i++;
                }
            }
			//hardcode
            while (i < numCards)
            {
                Card card3 = ((Card)cards[i]);
                bottomPile.Add(new Card(card3.getValue(), card3.getSuit(),this)); //card3
                i++;
            }
            ((List<Card>)(bottomPile)).Sort();
            ((List<Card>)(bottomPile)).Reverse();

            for (int j = 0; j < numPiles; j++)
            {
                ((List<Card>)(playerPiles[j])).Sort();
                ((List<Card>)(playerPiles[j])).Reverse();
            }
        }

        private List<Card> createDeck(int num)
        {
            List<Card> cards = new List<Card>();
            List<Card> dealtPile = new List<Card>();

            int[] values = new int[15] {CardValue.JOKERBLACK, CardValue.JOKERRED, CardValue.TWO, CardValue.THREE, CardValue.FOUR,
                            CardValue.FIVE, CardValue.SIX, CardValue.SEVEN, CardValue.EIGHT,
                            CardValue.NINE, CardValue.TEN, CardValue.JACK, CardValue.QUEEN,
							CardValue.KING, CardValue.ACE};

            int[] suits = new int[4] { Suit.DIAMONDS, Suit.CLUBS, Suit.HEARTS, Suit.SPADES };
            int[] colors = new int[1] { Suit.JOKER };//int[2] { Suit.BLACK, Suit.RED };
            int i = 0;
            for (int a = 0; a < numDecks; a++)
    		{
    			while ( i < values.Length )
    			{
    				if (i == 0 || i == 1)
    				{
                        //joker suit
						Card card = new Card( values[i], Suit.JOKER ,this);
						cards.Add( card );
    				}
    				else
    				{
    					// For each card value, loop over all 4 suits and add a card to the deck
    					for ( int k = 0; k < suits.Length; k++ )
    					{
    						// Create a new card...
    						Card card2 = new Card( values[i], suits[k] ,this);
    						// ...and add it to our deck
    						cards.Add( card2 );
    					}
    				}
    				i++; // Next card value
    			}
    			i = 0; //start at joker
    		}

            return cards;
        }
        
        public void shuffle()
    	{
    		List<Card> tempCards = new List<Card>();
            Random rand = new Random();
    		// Save the length of the cards since it will vary for each
    		// loop iteration
    		int l = cards.Count;
    		for (int i = 0; i < l; i++)
    		{
    			// Pick out a random card from the undealt cards
    			int randomIndex = (int)(Math.Floor( rand.NextDouble() * cards.Count ));
    							
    			// Remove the card at the index from the card pile
    			// and add the card to the tempCards array
                Card c = (Card)(cards.GetRange(randomIndex, 1)[0]);
                cards.RemoveRange(randomIndex, 1);
    			tempCards.Add(c);
    		}
    		
    		// At this point, cards is empty and tempCards contains the cards
    		// in random order, so copy the tempCard values into cards
    		for (int i = 0; i < l; i++)
    		{
    			cards.Add( tempCards[i] );
    		}
    		
    	}

    }

	/// <summary>
	/// Each instance of this class represents one game.
	/// 
	/// </summary>

    //[GameSetup.Integer("numDecks", "# of Decks", "How many decks?", 2, 4, 2)]
    [GameSetup.Options("numPlayers", "# of Players", "How many players?", 
	"4", "6", "8")]
	public class Game : NonobaGame<Player> {
        private ArrayList players;
        //private Player hasTurn;
        private int numPlayers;
        private Tuolaji instance;
        private int numShowed = 1;
        private int numNoBottom = 0;
        private int numDecks;
		/// <summary>
		/// Game started is called *once* when an instance
		/// of your game is started. It's a good place to initialize
		/// your game.
		/// </summary>
		public override void GameStarted() {
            //numPlayers = 1;
            numPlayers = Int32.Parse(Setup.GetString("numPlayers"));
            numDecks = numPlayers/2;
            MaxUsers = numPlayers;
            SetState(NonobaGameState.WaitingForPlayers);
            instance = new Tuolaji(numPlayers,numDecks);
            players = new ArrayList();
            for (int i = 0; i < numPlayers; i++)
                players.Add(null);

			// You can schedule a onetime callback for later. 
			// In this case, we're sending out a onetime "delayedhello"
			// message 10000 milliseconds (10 seconds) after the 
			// game is started
			/*ScheduleCallback(delegate {
				Broadcast("delayedhello");
			}, 10000);*/

			// You can setup timers to issue regular callbacks
			// in this case, the tick() method will be called
			// every 100th millisecond (10 times a second).
			//AddTimer(new TimerCallback(tick), 1000);
		}

		/*/// <summary>Timer callback scheduled to be called 10 times a second in the AddTimer() call in GameStarted()</summary>
		private void tick() {

			Console.WriteLine("Use Console.WriteLine() for easy debugging");

			RefreshDebugView(); // update the visual debugging view
			Broadcast("tick");
		}*/

        //when a user joins
		public override void UserJoined(Player player) {
            joinGame(player); 
		}

        private void joinGame(Player player)
        {
            Boolean allPlayers = true;
            for (int i = 0; i < numPlayers; i++)
            {
                if (players[i] == null)
                {
                    player.Send("playerinit", i, player.Username);
                    players[i] = player;
                    ((Player)(players[i])).setPlayerName(player.Username);
                    ((Player)(players[i])).setPlayerNum(i);
                    break;
                }
            }
            if (Users.Length > numPlayers)
            {
                var m = new Message("joined");
                m.Add(numPlayers);
                for (int i = 0; i < players.Count; i++) //players.Count
                {
                    m.Add(((Player)(players[i])).getPlayerName());
                }
                player.Send(m);

                player.Send("spectator");
                //do spectator game state with only showing the deals (no ppl hands)
                sendCurrentGameState(player);
                return;
            }
            if (players.Count == numPlayers)
            {
                allPlayers = true;
                for (int i = 0; i < numPlayers; i++)
                {
                    if (players[i] == null)
                    {
                        allPlayers = false;
                        break;
                    }
                }
                if (allPlayers == true)
                {
                    SetState(NonobaGameState.OpenGameInProgress);

                    var m = new Message("joined");
                    m.Add(numPlayers);
                    for (int i = 0; i < players.Count; i++)
                    {
                        m.Add(((Player)(players[i])).getPlayerName());
                    }
                    Broadcast(m);
					//reset?
                    instance.setMaster(-1);
                    instance.setCurrentLevel(2);
                    resetGame();
                }
            }
        }

        //when a user leaves
		public override void UserLeft(Player player) {
            if (player.playerNum != -1)
            {
                int b = player.playerNum;
                if (players.Count < numPlayers)
                {
                    SetState(NonobaGameState.WaitingForPlayers);
                    for (int i = 0; i < players.Count; i++)
                    {
                        if (player == players[i])
                            players[i] = null;
                    }
                }
                Broadcast("leave", b);
            }
		}

        /// <summary>This message is called whenever a player sends a message into the game.</summary>
        public override void GotMessage(Player player, Message m)
        {
            switch (m.Type)
            {
                case "getscores":
                   {
                       for (int i = 0; i < Users.Length; i++)
                       {
                           player.Send("score", Users[i].Username, Users[i].rank);
                       }
                       break;
                   }
                case "reset":
                    {
                        Boolean allPlayers = true;
                        for (int i = 0; i < players.Count; i++)
                        {
                            if (players[i] == null)
                            {
                                allPlayers = false;
                                break;
                            }
                        }
                        if (allPlayers == true)
                        {
                            player.setReady(true);
                            allPlayers = true;
                            for (int i = 0; i < players.Count; i++)
                            {
                                Player p = (Player)(players[i]);
                                if (p.isPlayerReady() == false)
                                {
                                    allPlayers = false;
                                    break;
                                }
                            }
                            if (allPlayers == true)
                            {
								instance.setMaster(-1);
								instance.setCurrentLevel(2);
                                //hasTurn = master;
                                //firstTurn = master;
                                resetGame();
                            }
                        }
                        break;
                    }
                case "join":
                    {
                        joinGame(player);
                        break;
                    }
                case "choosetrump":
                    {
                        int pNum = m.GetInt(0);
                        int suit = m.GetInt(1);
                        int numC = m.GetInt(2);
                        instance.changeSuit(suit,numC);

                        m = new Message("newsuit");
                        m.Add(pNum);
                        m.Add(suit);
                        m.Add(numC);
                        Broadcast(m);

                        break;
                    }
                case "giveBottom":
                    {
                        if (instance.getCurrentMaster() == -1)
                        {
                            instance.setMaster(player.playerNum);
                        }
						instance.setFirstTurn(instance.getCurrentMaster());
                        instance.setTurn(instance.getCurrentMaster());
                        int numCardsDeal = instance.getBottomPile().Count;
                        m = new Message("getBottom");
                        m.Add(numCardsDeal);
                        for (int j = 0; j < numCardsDeal; j++)
                        {
                            Card c = (Card)(instance.getBottomPile()[j]);
                            m.Add(c.getValue());
                            m.Add(c.getSuit());
                        }

                        //only for first game - setTurn = master when over
                        ((Player)(players[instance.getCurrentMaster()])).Send(m);
                        break;
                    }
                case "sendBottom":
                    {
                        instance.resetBottomPile();
                        for (uint d = 1; d < m.GetInt(0) * 2 + 1; d += 2)
    					{
    						Card c = new Card(m.GetInt(d),m.GetInt(d + 1),instance);
    						instance.getBottomPile().Add(c);
    					}
                        break;
                    }
                case "sendPlayerPile":
                    {
                        instance.resetPlayerPile(player.getPlayerNum());
                        for (uint d = 1; d < m.GetInt(0) * 2 + 1; d += 2)
                        {
                            Card c = new Card(m.GetInt(d), m.GetInt(d + 1), instance);
                            instance.getPlayerPiles(player.getPlayerNum()).Add(c);
                        }
                        break;
                    }
                case "start":
                    {
                        Broadcast("start",instance.getCurrentMaster(),instance.getCurrentLevel());
                        Broadcast("unselectall");
                        Broadcast("clear cards");
                        Broadcast("play", instance.getTurn(), false, instance.getFirstTurn());
                        break;
                    }
                case "sendIfLegit":
                    {
						Boolean legit = true;
						//check if illegit
                        List<Card> p = instance.getPlayerPiles(player.playerNum);
						for (uint d = 1; d < m.GetInt(0) * 2 + 1; d += 2)
                        {
                            Card c = new Card(m.GetInt(d), m.GetInt(d + 1), instance);
                            int inde = p.IndexOf(c);
							if (inde == -1)
							{
								legit = false;
								break;
							}
                            instance.getHandPiles(player.playerNum).Add(p.GetRange(inde,1)[0]);
                        }
						instance.sendCardsOrganize(player.playerNum);

                        Message showO = new Message("showOrganized");
                        ArrayList o = instance.getHandPilesOrganized(player.playerNum);
                        int num = o.Count;
                        for (int j = 0; j < o.Count; j++)
                        {
                            num += ((List<Card>)(o[j])).Count;
                        }
                        showO.Add(num);
                        for (int j = 0; j < o.Count; j++)
                        {
                            for (int k = 0; k < ((List<Card>)(o[j])).Count; k++)
                            {
                                Card c = (Card)(((List<Card>)(o[j]))[k]);
                                showO.Add(c.getValue());
                                //showO.Add(c.getSuit());          
                            }
                            showO.Add(-1);
                        }
                        Broadcast(showO);

                        Message showO2 = new Message("showOrganizedShuai");
                        ArrayList o2 = instance.getHandPilesShaui(player.playerNum);
                        int num2 = o2.Count;
                        showO2.Add(num2);
                        for (int j = 0; j < o2.Count; j++)
                        {
                            showO2.Add(((ShuaiPart)(o2[j])).ToString());
                        }
                        Broadcast(showO2);

						if (instance.checkLegit(player.playerNum) == true && legit == true)
							legit = true;
						else
							legit = false;
						
						if (legit == true)
						{
                            ((Player)(players[player.playerNum])).Send("legit");
						}
						else
						{
                            //message played illegit
                            Broadcast("unselectall");
                            if (player.playerNum == instance.getFirstTurn())
                            {
                                //so illegit
                                List<Card> hand = instance.getHandPiles(player.playerNum);
                                Message show = new Message("showhand");
                                show.Add(hand.Count);
                                for (int d = 0; d < hand.Count; d += 1)
                                {
                                    Card c = (Card)hand[d];
                                    show.Add(c.getValue(), c.getSuit());
                                }
                                show.Add(player.playerNum);
                                Broadcast(show);

                                ScheduleCallback(delegate
                                {
                                    Message illegit = new Message("illegit");
                                    List<Card> illegitList = instance.getIllegitPart();
                                    illegit.Add(illegitList.Count);
                                    for (int i = 0; i < illegitList.Count; i++)
                                    {
                                        Card c = (Card)illegitList[i];
                                        illegit.Add(c.getValue(), c.getSuit());
                                    }
                                    Broadcast(illegit);
                                    //Broadcast("play", instance.nextTurn(), true, instance.getFirstTurn());
                                }, 3000);
                            }
                            else
                            {
                                Broadcast("play", instance.getTurn(), true, instance.getFirstTurn());
                            }

                            instance.resetHandPile(player.playerNum);
                            instance.resetHandOrganizedPile(player.playerNum);
                            instance.resetHandShuaiPile(player.playerNum);
						}
                        break;
                    }
                case "sendCards":
                    {
                        //show
                        Message show = new Message("showhand");
                        show.Add(m.GetInt(0));
                        List<Card> p = instance.getPlayerPiles(player.playerNum);
                        for (uint d = 1; d < m.GetInt(0) * 2 + 1; d += 2)
                        {
                            Card c = new Card(m.GetInt(d), m.GetInt(d + 1), instance);
                            //List<Card> p = instance.getPlayerPiles(player.playerNum);
                            instance.addPoints(c);
                            //int inde = p.IndexOf(c);
                            //instance.getHandPiles(player.playerNum).Add(p.GetRange(inde,1)[0]);
                            p.Remove(c);
                            show.Add(m.GetInt(d), m.GetInt(d + 1));
                        }
                        show.Add(player.playerNum);
                        Broadcast(show);

                        if (numShowed != instance.getNumPiles())
                        {
                            numShowed++;
                            Broadcast("unselectall");
                            Broadcast("play", instance.nextTurn(), false, instance.getFirstTurn());
                        }
                        else
                        {
                            numShowed = 1;
                            int whoWon = instance.evalHands();

                            ////set turn to winner - wait 5 secs to see card
                            ScheduleCallback(delegate
                            {
                                Broadcast("clear cards");
                                Broadcast("points", instance.getCurrentPoints());
                                if (instance.getPlayerPiles(0).Count != 0)
                                {
                                    Broadcast("unselectall");
                                    Broadcast("play", instance.getTurn(), false, instance.getFirstTurn());
                                }
                                else
                                {
                                    //check points on bottom

                                    Message showB = new Message("showBottom");
                                    showB.Add(instance.getNumCardsBottom());
                                    for (int j = 0; j < instance.getNumCardsBottom(); j++)
                                    {
                                        Card c = (Card)(instance.getBottomPile()[j]);
                                        showB.Add(c.getValue());
                                        showB.Add(c.getSuit());
                                    }
                                    if (instance.getCurrentMaster() % 2 == 0)
                                        if (whoWon % 2 == 0)
                                            showB.Add(instance.giveBottomPoints());
                                        else
                                            showB.Add(0);
                                    else
                                        if (whoWon % 2 == 1)
                                            showB.Add(instance.giveBottomPoints());
                                        else
                                            showB.Add(0);

                                    showB.Add(instance.getNumPts());
                                    Broadcast(showB);

                                    ScheduleCallback(delegate
                                    {
                                        endRound();
                                    }, 4000);
                                }
                            }, 3000);
                        }
                        break;
                    }
                case "noBottom":
                    {
                        numNoBottom = numNoBottom + 1;
                        if (numNoBottom == numPlayers)
                        {
                            //later implement when no one fans (take card from bottom)
                            instance.changeSuit(0, 1);
                            m = new Message("newsuit");
                            m.Add(-1);
                            m.Add(0);
                            m.Add(1);
                            Broadcast(m);

                            int defMaster = 0;
                            if (instance.getCurrentMaster() == -1)
                            {
                                instance.setMaster(defMaster);
                            }
                            instance.setFirstTurn(instance.getCurrentMaster());
                            instance.setTurn(instance.getCurrentMaster());
                            int numCardsDeal = instance.getBottomPile().Count;
                            m = new Message("getBottom");
                            m.Add(numCardsDeal);
                            for (int j = 0; j < numCardsDeal; j++)
                            {
                                Card c = (Card)(instance.getBottomPile()[j]);
                                m.Add(c.getValue());
                                m.Add(c.getSuit());
                            }

                            //only for first game - setTurn = master when over
                            ((Player)(players[instance.getCurrentMaster()])).Send(m);
                            numNoBottom = 0;
                        }
                        break;
                    }
            }
        }

        //even
        private void endRound()
        {
            int checkWin = instance.checkPoints(players);

            if (checkWin == -1)
                resetGame();
            else
            {
                if (checkWin % 2 == 0)
                {
                    for (int i = 0; i < numPlayers; i += 2)
                        ((Player)(players[i])).SubmitRankingDelta("won", 1);
                    for (int i = 1; i < numPlayers; i += 2)
                        ((Player)(players[1])).SubmitRankingDelta("lost", 1);
                }
                else
                {
                    for (int i = 0; i < numPlayers; i += 2)
                        ((Player)(players[i])).SubmitRankingDelta("lost", 1);
                    for (int i = 1; i < numPlayers; i += 2)
                        ((Player)(players[1])).SubmitRankingDelta("won", 1);
                }

                Message win = new Message("win");
                win.Add(checkWin);
                Broadcast(win);
            }
        }

        private void resetGame()
        {
            for (int i = 0; i < players.Count; i++)
            {
                ((Player) (players[i])).SubmitRankingDelta("played", 1);
                ((Player) (players[i])).setReady(false);
            }

            var m = new Message("reset");

            instance.reset();
            instance.shuffle();
            instance.deal();

            m.Add(instance.getCards().Count); //message 0
            m.Add(instance.getCurrentLevel());
            m.Add(instance.getCurrentSuit());
            m.Add(instance.getNumPiles());
            m.Add(instance.getNumDecks());
            m.Add(instance.getNumCardsBottom());
			m.Add(instance.getCurrentMaster());
            Broadcast(m);

            int numCardsDeal = instance.getPlayerPiles(0).Count;
            for (int i = 0; i < players.Count; i++)
            {
                m = new Message("dealcards");
                m.Add(numCardsDeal);
                for (int j = 0; j < numCardsDeal; j++)
                {
                    Card c = (Card)(((List<Card>)(instance.getPlayerPiles(i)))[j]);
                    m.Add(c.getValue());
                    m.Add(c.getSuit());
                }
                ((Player)(players[i])).Send(m);
            }
        }

        public void sendCurrentGameState(Player p)
        {
            /*var m = new Message("reset");

            m.Add(instance.getCards().Count); //message 0
            m.Add(instance.getCurrentLevel());
            m.Add(instance.getCurrentSuit());
            m.Add(instance.getNumPiles());
            m.Add(instance.getNumDecks());
            m.Add(instance.getNumCardsBottom());
            m.Add(instance.getCurrentMaster());
            Broadcast(m);*/
        }

		/// <summary>
		/// This method can be used to generate a visual debugging image, that
		/// will be displayed in the Development Server. 
		/// Call RefreshDebugView() to update image.
		/// </summary>
		public override Image GenerateDebugImage() {
			// example code creating a 100x100 image and drawing the string "hello world" on it.
			Bitmap image = new Bitmap(100, 100);
			using (Graphics g = Graphics.FromImage(image)) {
				g.FillRectangle(Brushes.DarkGray, 0, 0, 100, 100);
				g.DrawString("Hello World",new Font("verdana",10F), Brushes.Black, 0,0);
			}
			return image;
		}
	}
}
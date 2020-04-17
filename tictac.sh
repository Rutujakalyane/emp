#!/bin/bash -x
echo "Welcome to TicTacToe"
#constants
NUM_OFROWS=3
NUM_OFCOLUMNS=3
EMPTY=0
PLAYER_SYM=''
COMP_SYM=''
LENGTH=$(( $NUM_OFROWS * $NUM_OFCOLUMNS ))

#variables
cell=1
playerCell=''
playerTurn=''
isCenterAvailable=''
isCornerAvailable=''
isSideAvailable=''
cellBlocked=''

declare -A board

function resetBoard()
{  
   local i=0
   local j=0

   for ((i=0; i<NUM_OFROWS; i++))
   do
      for ((j=0; j<NUM_OFCOLUMNS; j++))
      do
         board[$i,$j]=$EMPTY
      done
   done
}

function initializeBoard()
{  
   local x=0
   local y=0
   for (( x=0; x<NUM_OFROWS; x++ ))
   do
      for (( y=0; y<NUM_OFCOLUMNS; y++ ))
      do
         board[$x,$y]=$cell
         ((cell++))
      done
   done
}

function assigningSymbol()
{
   if [ $(( RANDOM%2 )) -eq 1 ]
   then
      PLAYER_SYM=X
      COMP_SYM=O
   else
      COMP_SYM=X
      PLAYER_SYM=O
   fi
   echo "Player's Symbol - $PLAYER_SYM"
}

function toss()
{
   if [ $(( RANDOM%2 )) -eq 1 ]
   then
      playerTurn=1
      echo "Player's turn" 
   else
      playerTurn=0
      echo "Computer's turn"
   fi
}

function displayBoard()
{
   echo "##### TicTacToe Board #####"
   local i=0
   local j=0
   for (( i=0; i<NUM_OFROWS; i++ ))
   do
      for (( j=0; j<NUM_OFCOLUMNS; j++ ))
      do
         echo -n "|   ${board[$i,$j]}   |"
      done
	 printf "\n"
   done
}

function inputToBoard()
{
   local rowIndex=''
   local columnIndex=''

   for (( i=0; i<$LENGTH; i++))
   do
      echo "###########################"
      displayBoard
      if [ $playerTurn -eq 1 ]
      then
      read  -p "Choose one cell for input : " playerCell

         if [ $playerCell -gt $LENGTH ]
         then
            echo "Invalid move, Select valid cell"
            printf "\n"
            ((i--))
         else
            rowIndex=$(( $playerCell / $NUM_OFROWS ))
               if [ $(( $playerCell % $NUM_OFROWS )) -eq 0 ]
               then
                  rowIndex=$(( $rowIndex - 1 ))
               fi

            columnIndex=$(( $playerCell %  $NUM_OFCOLUMNS ))
               if [ $columnIndex -eq 0 ]
               then
                  columnIndex=$(( $columnIndex + 2 ))
               else
                  columnIndex=$(( $columnIndex - 1 ))
               fi

               if [ "${board[$rowIndex,$columnIndex]}" == "$PLAYER_SYM" ] || [ "${board[$rowIndex,$columnIndex]}" == "$COMP_SYM" ]
               then
                  echo "Invalid move, Cell already filled"
                  printf "\n"
                  ((i--))
               else
                  board[$rowIndex,$columnIndex]=$PLAYER_SYM
                  playerTurn=0

                  if [ $(checkWinner $PLAYER_SYM) -eq 1  ]
                  then
                     echo "You Won"
                     return 0
                  fi
               fi
            fi
      else
         echo "#### Computer's Turn ######"
         checkingWinningCellForComputer
         if [ $(checkWinner $COMP_SYM) -eq 1  ]
         then
            echo "Computer Won"
            return 0
         fi
         computerCheckingPlayerWinningCellForBlocking
         if [[ $cellBlocked == true ]]
         then
            cellBlocked=false
         else
            checkCornersCenterSidesAvailability
            if [ $isCornerAvailable == true ] || [ $isCenterAvailable == true ] || [ $isSideAvailable == true ]
               then
                  isCornerAvailable=false
                  isCenterAvailable=false
                  isSideAvailable=false
            fi
         fi
         playerTurn=1
      fi
   done
   echo "Match Tie"
}

function checkWinner()
{
   local symbol=$1

   if [ ${board[0,0]} == $symbol ] && [ ${board[0,1]} == $symbol ] && [ ${board[0,2]} == $symbol ]
   then
      echo 1
   elif [ ${board[1,0]} == $symbol ] && [ ${board[1,1]} == $symbol ] && [ ${board[1,2]} == $symbol ]
   then
      echo 1
   elif [ ${board[2,0]} == $symbol ] && [ ${board[2,1]} == $symbol ] && [ ${board[2,2]} == $symbol ]
   then
      echo 1
   elif [ ${board[0,0]} == $symbol ] && [ ${board[1,0]} == $symbol ] && [ ${board[2,0]} == $symbol ]
   then
      echo 1
   elif [ ${board[0,1]} == $symbol ] && [ ${board[1,1]} == $symbol ] && [ ${board[2,1]} == $symbol ]
   then
      echo 1
   elif [ ${board[0,2]} == $symbol ] && [ ${board[1,2]} == $symbol ] && [ ${board[2,2]} == $symbol ]
   then
      echo 1
   elif [ ${board[0,0]} == $symbol ] && [ ${board[1,1]} == $symbol ] && [ ${board[2,2]} == $symbol ]
   then
      echo 1
   elif [ ${board[2,0]} == $symbol ] && [ ${board[1,1]} == $symbol ] && [ ${board[0,2]} == $symbol ]
   then
      echo 1
   else
      echo 0
   fi
}

function  computerCheckingPlayerWinningCellForBlocking()
{
#Rows--------------------------------------------------------------------------------------------------------------------------------------------->
   if [[ $cellBlocked == false ]]
   then
      local row=0
      local col=0
      for ((row=0; row<NUM_OFROWS; row++))
      do
         if [ ${board[$row,$col]} == $PLAYER_SYM ] && [ ${board[$(($row)),$(($col+1))]} == $PLAYER_SYM ]
         then
           if [ ${board[$row,$(($col+2))]} != $COMP_SYM ]
           then
              board[$row,$(($col+2))]=$COMP_SYM
              cellBlocked=true
              break
           fi
         elif [ ${board[$row,$(($col+1))]} == $PLAYER_SYM ] && [ ${board[$row,$(($col+2))]} == $PLAYER_SYM ]
         then
            if [ ${board[$row,$col]} != $COMP_SYM ]
            then
               board[$row,$col]=$COMP_SYM
               cellBlocked=true
               break
            fi
         elif [ ${board[$row,$col]} == $PLAYER_SYM ] && [ ${board[$row,$(($col+2))]} == $PLAYER_SYM ]
         then
            if [ ${board[$row,$(($col+1))]} != $COMP_SYM ]
            then
               board[$row,$(($col+1))]=$COMP_SYM
               cellBlocked=true
               break
            fi
         fi
      done

#Columns------------------------------------------------------------------------------------------------------------------------------------------->
   elif [[ $cellBlocked == false ]]
   then
      local row=0
      local col=0
      for ((col=0; col<NUM_OFCOLUMNS; col++))
      do
         if [ ${board[$row,$col]} == $PLAYER_SYM ] &&  [ ${board[$(($row+1)),$col]} == $PLAYER_SYM ]
         then
            if [ ${board[$(($row+2)),$col]} != $COMP_SYM ]
            then
               board[$(($row+2)),$col]=$COMP_SYM
               cellBlocked=true
               break
            fi
         elif [ ${board[$(($row+1)),$col]} == $PLAYER_SYM ] && [ ${board[$(($row+2)),$col]} == $PLAYER_SYM ]
         then
            if [ ${board[$row,$col]} != $COMP_SYM ]
            then
               board[$row,$col]=$COMP_SYM
               cellBlocked=true
               break
            fi
         elif [ ${board[$row,$col]} == $PLAYER_SYM ] && [ ${board[$(($row+2)),$col]} == $PLAYER_SYM ]
         then
            if [ ${board[$(($row+1)),$col]} != $COMP_SYM ]
            then
               board[$(($row+1)),$col]=$COMP_SYM
               cellBlocked=true
               break
            fi
         fi
      done

#Diagonal----------------------------------------------------------------------------------------------------------------------------------------->

   elif [[ $cellBlocked == false ]]
   then
      local row=0
      local col=0

      if [ ${board[$row,$col]} == $PLAYER_SYM ] &&  [ ${board[$(($row+1)),$(($col+1))]} == $PLAYER_SYM ]
      then
         if [ ${board[$(($row+2)),$(($col+2))]} != $COMP_SYM ]
         then
            board[$(($row+2)),$(($col+2))]=$COMP_SYM
            cellBlocked=true
            return
         fi
      elif [ ${board[$(($row+1)),$(($col+1))]} == $PLAYER_SYM ] && [ ${board[$(($row+2)),$(($col+2))]} == $PLAYER_SYM ]
      then
         if [ ${board[$row,$col]} != $COMP_SYM ]
         then
            board[$row,$col]=$COMP_SYM
            cellBlocked=true
            return
          fi
      elif [ ${board[$row,$col]} == $PLAYER_SYM ] && [ ${board[$(($row+2)),$(($col+2))]} == $PLAYER_SYM ]
      then
         if [ ${board[$(($row+1)),$(($col+1))]} != $COMP_SYM ]
         then
            board[$(($row+1)),$(($col+1))]=$COMP_SYM
            cellBlocked=true
            return
          fi
      elif [ ${board[$(($row+2)),$col]} == $PLAYER_SYM ] &&  [ ${board[$(($row+1)),$(($col+1))]} == $PLAYER_SYM ]
      then
         if [ ${board[$row,$(($col+2))]} != $COMP_SYM ]
         then
            board[$row,$(($col+2))]=$COMP_SYM
            cellBlocked=true
            return
          fi
      elif [ ${board[$(($row+1)),$(($col+1))]} == $PLAYER_SYM ] && [ ${board[$row,$(($col+2))]} == $PLAYER_SYM ]
      then
         if [ ${board[$(($row+2)),$col]} != $COMP_SYM ]
         then
            board[$(($row+2)),$col]=$COMP_SYM
            cellBlocked=true
            return
          fi
      elif [ ${board[$(($row+2)),$col]} == $PLAYER_SYM ] && [ ${board[$row,$(($col+2))]} == $PLAYER_SYM ]
      then
         if [ ${board[$(($row+1)),$(($col+1))]} != $COMP_SYM ]
         then
            board[$(($row+1)),$(($col+1))]=$COMP_SYM
            cellBlocked=true
            return
         fi
      fi
   fi
}


function checkingWinningCellForComputer()
{
#Rows---------------------------------------------------------------------------------------------------------------------------------------------->

   local row=0
   local col=0
   for ((row=0; row<NUM_OFROWS; row++))
   do
      if [ ${board[$row,$col]} == $COMP_SYM ] && [ ${board[$(($row)),$(($col+1))]} == $COMP_SYM ]
      then
         if [ ${board[$row,$(($col+2))]} != $PLAYER_SYM ]
          then
             board[$row,$(($col+2))]=$COMP_SYM
             break
          fi
      elif [ ${board[$row,$(($col+1))]} == $COMP_SYM ] && [ ${board[$row,$(($col+2))]} == $COMP_SYM ]
      then
          if [ ${board[$row,$col]} != $PLAYER_SYM ]
          then
             board[$row,$col]=$COMP_SYM
             break
          fi
      elif [ ${board[$row,$col]} == $COMP_SYM ] && [ ${board[$row,$(($col+2))]} == $COMP_SYM ]
      then
          if [ ${board[$row,$(($col+1))]} != $PLAYER_SYM ]
          then
             board[$row,$(($col+1))]=$COMP_SYM
             break
          fi
      fi
   done

#Columns------------------------------------------------------------------------------------------------------------------------------------------->

   local row=0
   local col=0
   for ((col=0; col<NUM_OFCOLUMNS; col++))
   do
      if [ ${board[$row,$col]} == $COMP_SYM ] &&  [ ${board[$(($row+1)),$col]} == $COMP_SYM ]
      then
         if [ ${board[$(($row+2)),$col]} != $PLAYER_SYM ]
         then
            board[$(($row+2)),$col]=$COMP_SYM
            break
         fi
      elif [ ${board[$(($row+1)),$col]} == $COMP_SYM ] && [ ${board[$(($row+2)),$col]} == $COMP_SYM ]
      then
         if [ ${board[$row,$col]} != $PLAYER_SYM ]
         then
            board[$row,$col]=$COMP_SYM
            break
          fi
      elif [ ${board[$row,$col]} == $COMP_SYM ] && [ ${board[$(($row+2)),$col]} == $COMP_SYM ]
      then
         if [ ${board[$(($row+1)),$col]} != $PLAYER_SYM ]
         then
            board[$(($row+1)),$col]=$COMP_SYM
            break
         fi
      fi
   done

#Diagonal------------------------------------------------------------------------------------------------------------------------------------------>

      local row=0
      local col=0

      if [ ${board[$row,$col]} == $COMP_SYM ] &&  [ ${board[$(($row+1)),$(($col+1))]} == $COMP_SYM ]
      then
         if [ ${board[$(($row+2)),$(($col+2))]} != $PLAYER_SYM ]
         then
            board[$(($row+2)),$(($col+2))]=$COMP_SYM
            return
         fi
      elif [ ${board[$(($row+1)),$(($col+1))]} == $COMP_SYM ] && [ ${board[$(($row+2)),$(($col+2))]} == $COMP_SYM ]
      then
         if [ ${board[$row,$col]} != $PLAYER_SYM ]
         then
            board[$row,$col]=$COMP_SYM
            return
          fi
      elif [ ${board[$row,$col]} == $COMP_SYM ] && [ ${board[$(($row+2)),$(($col+2))]} == $COMP_SYM ]
      then
         if [ ${board[$(($row+1)),$(($col+1))]} != $PLAYER_SYM ]
         then
            board[$(($row+1)),$(($col+1))]=$COMP_SYM
            return
          fi
      elif [ ${board[$(($row+2)),$col]} == $COMP_SYM ] &&  [ ${board[$(($row+1)),$(($col+1))]} == $COMP_SYM ]
      then
         if [ ${board[$row,$(($col+2))]} != $PLAYER_SYM ]
         then
            board[$row,$(($col+2))]=$COMP_SYM
            return
          fi
      elif [ ${board[$(($row+1)),$(($col+1))]} == $COMP_SYM ] && [ ${board[$row,$(($col+2))]} == $COMP_SYM ]
      then
         if [ ${board[$(($row+2)),$col]} != $PLAYER_SYM ]
         then
            board[$(($row+2)),$col]=$COMP_SYM
            return
          fi
      elif [ ${board[$(($row+2)),$col]} == $COMP_SYM ] && [ ${board[$row,$(($col+2))]} == $COMP_SYM ]
      then
         if [ ${board[$(($row+1)),$(($col+1))]} != $PLAYER_SYM ]
         then
            board[$(($row+1)),$(($col+1))]=$COMP_SYM
            return
          fi
      else
         return
      fi
#------------------------------------------------------------------------------------------------------------------------------------------------>
}

function checkCornersCenterSidesAvailability()
{
      if [ ${board[0,0]} != $PLAYER_SYM ] && [ ${board[0,0]} != $COMP_SYM ]
      then
         board[0,0]=$COMP_SYM
         isCornerAvailable=true
      elif [ ${board[0,2]} != $PLAYER_SYM ] && [ ${board[0,2]} != $COMP_SYM ]
      then
         board[0,2]=$COMP_SYM
         isCornerAvailable=true
      elif [ ${board[2,0]} != $PLAYER_SYM ] && [ ${board[2,0]} != $COMP_SYM ]
      then
         board[2,0]=$COMP_SYM
         isCornerAvailable=true
      elif [ ${board[2,2]} != $PLAYER_SYM ] && [ ${board[2,2]} != $COMP_SYM ]
      then
         board[2,2]=$COMP_SYM
         isCornerAvailable=true
      elif [ ${board[1,1]} != $PLAYER_SYM ] && [ ${board[1,1]} != $COMP_SYM ]
      then
         board[1,1]=$COMP_SYM
         isCenterAvailable=true
      elif [ ${board[0,1]} != $PLAYER_SYM ] && [ ${board[0,1]} != $COMP_SYM ]
      then
         board[0,1]=$COMP_SYM
         isSideAvailable=true
      elif [ ${board[1,2]} != $PLAYER_SYM ] && [ ${board[1,2]} != $COMP_SYM ]
      then
         board[1,2]=$COMP_SYM
         isSideAvailable=true
      elif [ ${board[2,1]} != $PLAYER_SYM ] && [ ${board[2,1]} != $COMP_SYM ]
      then
         board[2,1]=$COMP_SYM
         isSideAvailable=true
      elif [ ${board[1,0]} != $PLAYER_SYM ] && [ ${board[1,0]} != $COMP_SYM ]
      then
         board[1,0]=$COMP_SYM
         isSideAvailable=true
      fi
}

#main

resetBoard
assigningSymbol
toss
initializeBoard
inputToBoard
displayBoard

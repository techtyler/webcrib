# To change this template, choose Tools | Templates
# and open the template in the editor.

module Crib
  module Util

    class HandCountingMethods

      def self.flush(cards)

        suit = cards.first.suit
        is_flush = true
        (1..cards.size-2).each { |i|
          if (cards[i].suit != suit)
            is_flush = false
          end
        }
        if is_flush
          if cards.last.suit == suit
            return cards.size
          else
            return (-1 + cards.size)
          end
        end
        return 0
      end

      def self.remove_duplicate_cards(cards)
        dups = {}
        tmp_cards = cards.dup
        (0..cards.size-2).each { |i|

          if (cards[i].number == cards[i+1].number)
            if (dups.key?(cards[i].number))
              val = dups[cards[i].number] + 1
              dups[cards[i].number] = val
            else
              dups[cards[i].number] = 1
            end
            tmp_cards.delete(cards[i])

          end

        }
        return tmp_cards,dups
      end

      def self.knobs(cards)
        cut_suit = cards.last.suit
        (1..cards.size - 2).each { |i|
          if cards[i].number == 11 && cards[i].suit == cut_suit
            return 1
          end
        }
        return 0
      end

      def self.sum(cards)
        score = 0
        cards.each do |card|
          score += card.value

        end
        return score
      end

      def self.fifteens_up(cards, tmp_sum, sum_count)

        tmp_cards = cards.dup
        sum_count += 1

        card_to_pull_next = 0

        if (tmp_sum == 15)
          return 2, sum_count
        elsif (tmp_sum > 15)
          return -1, sum_count
        elsif (tmp_sum < 5)
          if (tmp_cards.size < 2)
            return 0, sum_count
          end
          card_to_pull_next = cards.size-1 # -1?
        end
        score = 0

        if (!tmp_cards.empty? && (15 - tmp_sum >= tmp_cards.first.value))

          #tmp_sum < 15 - lowest_card
          while(!tmp_cards.empty?)

            tmp_sum_i = tmp_sum + tmp_cards[card_to_pull_next].value
            tmp_cards.delete(tmp_cards[card_to_pull_next])
            tmp_score, sum_count = HandCountingMethods.fifteens_up(tmp_cards, tmp_sum_i, sum_count)

            if (tmp_score > 0)
              score += tmp_score
            elsif (tmp_score < 0)
              break
            end

            if (tmp_sum_i < 5)
              if (tmp_cards.size < 2)
                return score, sum_count
              end
              card_to_pull_next = tmp_cards.size-1
            else
              card_to_pull_next = 0
            end

          end
        end
        return score, sum_count
      end

      def self.fifteens(cards)

        sum = HandCountingMethods.sum(cards)
        operation_count = 1
        fifteen_count = 0

        if sum == 15
          fifteen_count = 1
        elsif sum > 15

          (0..cards.size-1).each { |i|

            sum4 = sum - cards[i].value
            operation_count += 1 #TODO Remove performance testing
            if sum4 == 15
              fifteen_count+=1
            elsif sum4 < 15
              break
            else
              ((i+1)..cards.size-1).each { |j|

                sum3 = sum4 - cards[j].value
                operation_count += 1
                if (sum3 == 15)
                  fifteen_count+=1
                elsif sum3 < 15
                  break
                elsif sum3 - cards[j].value >= 15
                  ((j+1)..cards.size-1).each { |k|
                    sum2 = sum3 - cards[k].value
                    operation_count += 1
                    if (sum2 == 15)
                      fifteen_count+=1
                    elsif (sum2 < 15)
                      break
                    end
                  }
                end
              }
            end
          }
        end
        return fifteen_count * 2, operation_count
      end

      def self.pairs (dups)

        pair_count = 0
        dups.keys.each do |key|
          if (dups[key] == 1)
            pair_count += 1
          elsif dups[key] == 2
            pair_count += 3
          elsif dups[key] == 3
            pair_count += 6
          end
        end

        pair_count * 2

      end

      def self.do_cards_make_complete_run(cards)
        run = cards.size
        (1..cards.size-1).each { |i|
          if (cards[i].number - cards[i-1].number != 1)
            run = 0
          end
        }
        run
      end

      def self.score_runs(cards, dups)

        if (cards.size < 3)
          return 0
        end

        runs = 0
        max_run = HandCountingMethods.do_cards_make_complete_run(cards)
        if (max_run > 0)

          if dups.empty?
            #puts "no dups for run"
            runs += max_run
          else
            #puts "dups following"
            dups.keys.each do |key|
              #puts "dups value:" + dups[key].to_s
              runs += (dups[key]+1) * max_run
            end
          end

        else

          tmp_cards = cards.dup
          tmp_cards.delete(cards.first)
          tmp_dups = dups.dup
          tmp_dups.delete(cards.first.number)

          tmp_runs = HandCountingMethods.score_runs(tmp_cards, tmp_dups)

          if (tmp_runs > 0)
            runs += tmp_runs
          else
            tmp_cards = cards.dup
            tmp_cards.delete(cards[(cards.size - 1)])
            tmp_dups = dups.dup
            tmp_dups.delete(cards[(cards.size - 1)].number)
            runs += HandCountingMethods.score_runs(tmp_cards, tmp_dups)
          end

        end
        return runs
      end

      def self.score_hand(cards, crib)

        score = 0
        tmp_flush = HandCountingMethods.flush(cards)
        if (tmp_flush == 5 || (tmp_flush == 4 && !crib))
          score += tmp_flush
        end

        #puts "Score after flush check: " + score.to_s
        score += HandCountingMethods.knobs(cards)
        #puts "Score after knobs check: " + score.to_s
        cards.sort! { |a,b| a.number <=> b.number  }


        fif_score,sum_count = HandCountingMethods.fifteens_up(cards, 0, 0)
        #if (sum(cards) > 25)
        #  fif_score,sum_count = HandCountingMethods.fifteens_up(cards, 0, 0)
        #else
        #  fif_score,sum_count = HandCountingMethods.fifteens(cards)
        #end

        score += fif_score

        #puts "Score after fifteens check: " + score.to_s
        tmp_cards, dups = HandCountingMethods.remove_duplicate_cards(cards)

        #puts "Duplicates removed"
        score += HandCountingMethods.pairs(dups)
        #puts "Score after pairs check: " + score.to_s
        score += HandCountingMethods.score_runs(tmp_cards, dups)
        #puts "Score after runs check: " + score.to_s

        return score, sum_count

      end
    end
  end
end

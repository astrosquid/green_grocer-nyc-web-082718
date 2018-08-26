require 'pp'
require 'pry'

def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item|
    item_name = item.keys[0]
    if consolidated.keys.include?(item_name)
      consolidated[item_name][:count] += 1 
    else 
      consolidated[item_name] = {
        :price => item[item_name][:price],
        :clearance => item[item_name][:clearance],
        :count => 1 
      }
    end 
  end 
  consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item]) && coupon[:num] <= cart[coupon[:item]][:count]
      # apply discount and subtract from cart count 
      while cart[coupon[:item]][:count] >= coupon[:num] do 
        if cart.keys.include?("#{coupon[:item]} W/COUPON")
          cart["#{coupon[:item]} W/COUPON"][:count] += 1 
        else 
          cart["#{coupon[:item]} W/COUPON"] = {
            :count => 1,
            :price => coupon[:cost],
            :clearance => cart[coupon[:item]][:clearance]
          }
        end 
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end 
  end 
  # remove items that have a count of 0?
  cart 
end

def apply_clearance(cart)
  puts 'CART'
  pp cart 
  puts ''
  cart.each do |item|
    binding.pry
    if cart[item][:clearance] == true
      binding.pry
      item[:price] -= (item[:price] * 0.2).round(2)
    end 
  end 
  cart
end

def checkout(cart, coupons)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  price = 0.0 
  cart.each do |item|
    price += cart[item][:price]
  end
  if price > 100
    price = (price * 0.9).round(2)
  end
  price
end

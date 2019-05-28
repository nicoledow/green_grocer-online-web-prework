require "pry"

def consolidate_cart(cart)
  consolidated_cart = {}
  count = 0
  
  cart.each do |item|
    item.each do |name, data_set|
      consolidated_cart[name] ||= data_set
      consolidated_cart[name][:count] ||= 0
      consolidated_cart[name][:count] += 1
    end
  end
  
  consolidated_cart
end



def apply_coupons(cart, coupons)
 
  coupons.each do |coupon|
    discounted_item = coupon[:item]
    #check if cart contains coupon-eligible item AND if the numbers match exactly
    if cart.has_key?(discounted_item) && cart[discounted_item][:count] >= coupon[:num]
      #if so, add a new item with coupon to the cart_with_coupons
      cart["#{discounted_item} W/COUPON"] ||= {}
      cart["#{discounted_item} W/COUPON"][:price] = coupon[:cost]
      cart["#{discounted_item} W/COUPON"][:clearance] = cart[discounted_item][:clearance]
      cart["#{discounted_item} W/COUPON"][:count] = 1
      #removes number of discounted items from original item's count:
      cart[discounted_item][:count] -= coupon[:num]
      
    #need to be able to "increment coupon count if two are applied" -NOT YET SOLVED
    elsif cart.has_key?(discounted_item) && cart[discounted_item][:count] > coupon[:num]
      applicable_coupon_count = (cart[discounted_item][:count] / coupon[:num]).floor
      cart["#{discounted_item} W/COUPON"] ||= {}
      cart["#{discounted_item} W/COUPON"][:clearance] = cart[discounted_item][:clearance]
      cart["#{discounted_item} W/COUPON"][:count] += 1
      cart["#{discounted_item} W/COUPON"][:price] = coupon[:cost] * applicable_coupon_count
      cart[discounted_item][:count] = cart[discounted_item][:count] % coupon[:num]
    end
  end
  
  cart
end



#discounts the price of every item in the cart that is on clearance by 20%
def apply_clearance(cart)
  cart.each do |item, info_hash|
    if info_hash[:clearance] == true
      info_hash[:price] = (info_hash[:price] * 0.80).round(2)
    end
  end
end

def checkout(cart, coupons)
  cart_sum = 0
  
  cart = consolidate_cart(cart)
  cart = apply_clearance(cart)
  #cart = apply_coupons(cart)
  
  cart.each do |item, info|
    cart_sum += (info[:price] * info[:count])
  end
  
  if cart_sum > 100
    cart_sum *= 0.90
  end
  cart_sum.round(2)
end

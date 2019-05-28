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
    coupon_item = coupon[:item]
    
    #if cart contains coupon item and has equal or more than # of items necessary, adjust count of that item in the cart:
    if cart.has_key?(coupon_item) && cart[coupon_item][:count] >= coupon[:num]
      cart[coupon_item][:count] -= coupon[:num]
      
      #if a coupon for that item already exists in cart, increment its count:
      if cart.has_key?("#{coupon_item} W/COUPON")
        cart["#{coupon_item} W/COUPON"][:count] += 1 
        
      #if a coupon for that item has not yet been created in the cart, add it with the proper info
      else  
      cart["#{coupon_item} W/COUPON"] = {
        :price => coupon[:cost],
        :count => 1, 
        :clearance => cart[coupon_item][:clearance]
      }
      end 
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
  end_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  cart_sum = 0
  
  end_cart.each do |item, info|
    cart_sum += (info[:price] * info[:count])
  end
  
  if cart_sum > 100
    cart_sum *= 0.90
  end
  
  cart_sum.round(2)
end


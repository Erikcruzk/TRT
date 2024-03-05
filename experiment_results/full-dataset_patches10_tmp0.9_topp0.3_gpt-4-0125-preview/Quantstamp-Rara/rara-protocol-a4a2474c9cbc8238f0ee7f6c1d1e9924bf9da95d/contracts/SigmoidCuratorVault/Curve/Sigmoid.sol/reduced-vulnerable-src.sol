


pragma solidity 0.8.9;

library ExtendedMath {
    


    function pow2(int256 a) internal pure returns (int256) {
        if (a == 0) {
            return 0;
        }
        int256 c = a * a;
        require(c / a == a, "ExtendedMath: squaring overflow");
        return c;
    }

    function pow3(int256 a) internal pure returns (int256) {
        if (a == 0) {
            return 0;
        }
        int256 c = a * a;
        require(c / a == a, "ExtendedMath: cubing overflow2");

        int256 d = c * a;
        require(d / a == c, "ExtendedMath: cubing overflow3");
        return d;
    }

    


    function sqrt(int256 y) internal pure returns (int256 z) {
        require(y >= 0, "Negative sqrt");
        if (y > 3) {
            z = y;
            int256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}




pragma solidity 0.8.9;



contract Sigmoid {
    using ExtendedMath for int256;

    function n1(
        int256 a,
        int256 b,
        int256 c,
        int256 newReserves
    ) internal pure returns (int256) {
        return 2 * a.pow2() * b * newReserves * (b.pow2() + c).sqrt();
    }

    function n2(
        int256 a,
        int256 b,
        int256,
        int256 newReserves
    ) internal pure returns (int256) {
        return 2 * a.pow2() * b.pow2() * newReserves;
    }

    function n3(
        int256 a,
        int256,
        int256 c,
        int256 newReserves
    ) internal pure returns (int256) {
        return 2 * a.pow2() * c * newReserves;
    }

    function n4(
        int256 a,
        int256 b,
        int256 c,
        int256 newReserves
    ) internal pure returns (int256) {
        return a * newReserves.pow2() * (b.pow2() + c).sqrt();
    }

    function n5(
        int256 a,
        int256 b,
        int256,
        int256 newReserves
    ) internal pure returns (int256) {
        return 1 * a * b * newReserves.pow2();
    }

    function n6(
        int256,
        int256,
        int256,
        int256 newReserves
    ) internal pure returns (int256) {
        return newReserves.pow3();
    }

    function d1(
        int256 a,
        int256 b,
        int256 c,
        int256 newReserves
    ) internal pure returns (int256) {
        return
            a *
            (-2 *
                a.pow2() *
                c -
                4 *
                a *
                b *
                newReserves +
                2 *
                newReserves.pow2());
    }

    
    
    
    
    
    
    
    function calculateTokensBoughtFromPayment(
        int256 a,
        int256 b,
        int256 c,
        int256 currentTokensSupply,
        int256 paymentReserves,
        int256 paymentToSpend
    ) public pure returns (uint256) {
        
        int256 newReserves = paymentReserves + paymentToSpend;

        
        int256 newSupply = (n6(a, b, c, newReserves) +
            n4(a, b, c, newReserves) -
            n1(a, b, c, newReserves) -
            n2(a, b, c, newReserves) -
            n3(a, b, c, newReserves) -
            n5(a, b, c, newReserves)) / (d1(a, b, c, newReserves));

        
        return uint256(newSupply - currentTokensSupply);
    }

    
    
    
    
    
    
    
    function calculatePaymentReturnedFromTokens(
        int256 a,
        int256 b,
        int256 c,
        int256 currentTokenSupply,
        int256 paymentReserves,
        int256 tokensToSell
    ) public pure returns (uint256) {
        
        int256 newSupply = currentTokenSupply - tokensToSell;

        
        int256 constantVal = a * ((b.pow2() + c).sqrt());

        
        int256 newReserves = (a *
            (((b - newSupply).pow2() + c).sqrt() + newSupply)) - constantVal;

        
        return uint256(paymentReserves - newReserves);
    }
}
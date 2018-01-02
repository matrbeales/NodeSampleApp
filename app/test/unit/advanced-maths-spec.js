var chai = require('chai');
var expect = chai.expect;
var AdvancedMaths = require('../../modules/advanced-maths');

describe('AdvancedMaths', function() {
  describe('fibonacci()' , function() {
    it('should return 0 when 0 is entered', function() {
      expect(AdvancedMaths.fibonacci(0)).to.equal(0);
    });

    it('should return 1 when 1 is entered', function() {
      expect(AdvancedMaths.fibonacci(1)).to.equal(1);
    });

    it('should return 55 when 10 is entered', function() {
      expect(AdvancedMaths.fibonacci(10)).to.equal(55);
    });

    it('should return null when a negative number is entered', function() {
      expect(AdvancedMaths.fibonacci(-5)).to.equal(null);
    });

    it('should return null when null is passed', function() {
      expect(AdvancedMaths.fibonacci()).to.equal(null);
    });

    it('should return null when undefined is passed', function() {
      expect(AdvancedMaths.fibonacci()).to.equal(null);
    });
  });
});
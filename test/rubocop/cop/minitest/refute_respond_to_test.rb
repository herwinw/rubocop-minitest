# frozen_string_literal: true

require 'test_helper'

class RefuteRespondToTest < Minitest::Test
  def setup
    @cop = RuboCop::Cop::Minitest::RefuteRespondTo.new
  end

  def test_registers_offense_when_using_refute_calling_respond_to_method
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.respond_to?(:some_method))
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_respond_to(object, :some_method)` over `refute(object.respond_to?(:some_method))`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to(object, :some_method)
        end
      end
    RUBY
  end

  def test_registers_offense_when_using_refute_calling_respond_to_method_with_message
    assert_offense(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute(object.respond_to?(:some_method), 'the message')
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Prefer using `refute_respond_to(object, :some_method, 'the message')` over `refute(object.respond_to?(:some_method), 'the message')`.
        end
      end
    RUBY

    assert_correction(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to(object, :some_method, 'the message')
        end
      end
    RUBY
  end

  def test_does_not_register_offense_when_using_assert_respond_to
    assert_no_offenses(<<~RUBY, @cop)
      class FooTest < Minitest::Test
        def test_do_something
          refute_respond_to('rubocop-minitest', :some_method)
        end
      end
    RUBY
  end
end

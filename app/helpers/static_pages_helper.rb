# frozen_string_literal: true

module StaticPagesHelper
  ALPHABET_LISTING = %w[
    A
    B_open
    B_closed
    C_half
    C_full
    D
    E
    F
    G
    H
    I
    J
    K
    L
    M
    N
    O
    P_open
    P_closed
    Q
    R
    S
    T
    U
    V
    W
    X
    Y
    Z
  ].freeze

  def alphabet_listing
    ALPHABET_LISTING
  end
end

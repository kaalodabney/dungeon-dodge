def tick args

  args.state.rotation ||= 0
  args.outputs.labels  << [640, 500, 'Hello Rubah!', 5, 1]
  args.outputs.sprites << [576, 280, 128, 101, 'dragonruby.png', args.state.rotation]

  args.state.rotation -= 10000

end

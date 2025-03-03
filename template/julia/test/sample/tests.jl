using Test
import juliaEnvTest.sampleMod: addone
import juliaEnvTest.sampleMod2: square

@testset "Add one" begin
  @test addone(1) == 2
end

@testset "square" begin
  @test square(2) == 4
end

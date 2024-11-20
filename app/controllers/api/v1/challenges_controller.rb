module Api
    module V1
        class ChallengesController < ApplicationController
            before_action :authenticate_user!, only: %i[create update destroy]
            before_action :set_challenge, only: %i[show update destroy]
            before_action :authorize_admin, only: %i[create update destroy]

            #GET /api/v1/challenge
            def index
                # show all changes
                @challenges = Challenge.all
                render json: @challenges
            end

            def active_and_upcoming
                # show all changes
                @active_challenges = Challenge.active
                @upcoming_challenges= Challenge.upcoming
                @all = Challenge.all
                render json: { active: @active_challenges, upcoming: @upcoming_challenges }
            end
            
            #POST   /api/v1/challenges
            def create
                #create a challenge
                # challenge = Challenge.new(challenges_params.merge(user_id: current_user.id))
                challenge = current_user.challenges.build(challenges_params)
                if challenge.save
                    render json: { message: 'Challenge created successfully', data: challenge }
                else
                    render json: { message: 'Challenge not created', data: challenge.errors }, status: :unauthorized
                end


            end

            #GET    /api/v1/challenges/:id
            def show
                #show a challenge

                # challenge = Challenge.find(params[:id])
                if @challenge
                    render json: { message: 'Challenge found successfully', data: @challenge }
                else
                    render json: { message: 'Challenge not found succesfully', data: @challenge.errors }
                end
            end

            #PUT    /api/v1/challenges/:id
            def update
                #update a challenge
                # challenge = Challenge.find(params[:id])
                if @challenge.update(challenges_params)
                    render json: { message: 'Challenge updated successfully', data: @challenge }
                else
                    render json: { message: 'Challenge not updated succesfully', data: @challenge.errors }
                end

            end

            #DELETE /api/v1/challenges/:id
            def destroy
                # delete a challenge
                # challenge = Challenge.find(params[:id])
                if @challenge.destroy
                    render json: { message: 'Challenge deleted successfully', data: @challenge }
                else
                    render json: { message: 'Challenge not deleted succesfully', data: @challenge.errors }
                end
            end

            private
            def challenges_params
                params.require(:challenge).permit(:title, :description, :start_date, :end_date)
            end

            def set_challenge
                @challenge = Challenge.find(params[:id])
            end

            def authorize_admin
                render json: { message: 'Forbidden action' }, status: :unauthorized unless current_user.email == ENV['ADMIN_EMAIL']
                
            end
        end
    end
end

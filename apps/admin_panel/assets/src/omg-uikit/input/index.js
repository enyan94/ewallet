import React, { PureComponent } from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import ReactDOM from 'react-dom'

const Container = styled.div`
  position: relative;
  width: 100%;
`
const InnerContainer = styled.div`
  position: relative;
`

const Placeholder = styled.span`
  position: absolute;
  pointer-events: none;
  left: 0;
  bottom: 0;
  padding-bottom: 5px;
  font-size: 14px;
  transition:0.2s ease all;
  border-bottom: 1px solid transparent;
  color: ${props => props.theme.colors.B100};
`

const Input = styled.input`
  width: 100%;
  border: none;
  color: ${props => props.theme.colors.B300};
  padding-bottom: 5px;
  background-color: transparent;
  line-height: 1;
  border-bottom: 1px solid
    ${props => (props.error ? props.theme.colors.R400 : props.theme.colors.S400)};
  :-webkit-autofill
    ~ ${Placeholder},
    :disabled
    ~ ${Placeholder},
    :focus
    ~ ${Placeholder},
    :not(:focus):valid
    ~ ${Placeholder} {
    transform: ${props => `translate3d(0, -${props.placeholderMoveHeight}, 0)`};
  }
  :disabled {
    background-color: transparent;
  }
`
const Error = styled.div`
  color: ${props => props.theme.colors.R400};
  text-align: left;
  padding-top: ${props => (props.error ? '5px' : 0)};
  overflow: hidden;
  max-height: ${props => (props.error ? '30px' : 0)};
  opacity: ${props => (props.error ? 1 : 0)};
  transition: 0.5s ease max-height, 0.3s ease opacity,
    0.3s ease padding ${props => (!props.error ? '0.3s' : '0s')};
`
class InputComonent extends PureComponent {
  static propTypes = {
    placeholder: PropTypes.string,
    normalPlaceholder: PropTypes.string,
    className: PropTypes.string,
    registerRef: PropTypes.func,
    error: PropTypes.bool,
    errorText: PropTypes.node,
    autofocus: PropTypes.bool,
    onPressEnter: PropTypes.func,
    onPressEscape: PropTypes.func,
    onChange: PropTypes.func
  }
  static defaultProps = {
    placeholderType: 'float'
  }
  state = {
    placeholderMoveHeight: '2em'
  }

  handleKeyPress = e => {
    if (e.key === 'Enter') {
      return this.props.onPressEnter && this.props.onPressEnter()
    }
  }
  handleKeyDown =e => {
    if (e.key === 'Escape') {
      return this.props.onPressEscape && this.props.onPressEscape()
    }
  }

  componentDidMount = () => {
    if (this.props.autofocus) this.input.focus()
    this.registerRef()
    const inputNodeHeight = ReactDOM.findDOMNode(this.input).clientHeight
    this.setState({
      placeholderMoveHeight: inputNodeHeight
        ? `${ReactDOM.findDOMNode(this.input).clientHeight * 0.9}px`
        : '2em'
    })
  }
  onChange = e => {
    if (this.props.onChange) this.props.onChange(e)
  }

  registerRef = () => {
    if (this.props.registerRef) this.props.registerRef(this.input)
  }
  registerInput = input => (this.input = input)

  render () {
    const { className, placeholder, ...rest } = this.props
    return (
      <Container className={className}>
        <InnerContainer>
          <Input
            onKeyPress={this.handleKeyPress}
            onKeyDown={this.handleKeyDown}
            required
            innerRef={this.registerInput}
            error={this.props.error}
            placeholderMoveHeight={this.state.placeholderMoveHeight}
            {...rest}
            placeholder={this.props.normalPlaceholder}
            onChange={this.onChange}
          />
          <Placeholder>{placeholder}</Placeholder>
        </InnerContainer>
        <Error error={this.props.error}>{this.props.errorText}</Error>
      </Container>
    )
  }
}

export default InputComonent